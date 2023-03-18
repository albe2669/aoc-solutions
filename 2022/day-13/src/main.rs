use std::{env, fs};

#[derive(Debug, PartialEq, Eq, Clone)]
enum Packet {
    List(Vec<Packet>),
    Number(i32),
}

impl Ord for Packet {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        match (self, other) {
            (Packet::Number(a), Packet::Number(b)) => a.cmp(b),
            (Packet::List(a), Packet::List(b)) => a.cmp(b),
            (Packet::Number(a), Packet::List(b)) => vec![Self::Number(*a)].cmp(b),
            (Packet::List(a), Packet::Number(b)) => a.cmp(&vec![Self::Number(*b)]),
        }
    }
}

impl PartialOrd for Packet {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

type Input = Vec<(Packet, Packet)>;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .collect();

    let packets: Vec<(Packet, Packet)> = lines
        .chunks(2)
        .map(|chunk| {
            let left: Vec<char> = chunk[0].chars().collect();
            let right: Vec<char> = chunk[1].chars().collect();

            (parse_list(&left).0, parse_list(&right).0)
        })
        .collect();

    part1(&packets);
    part2(&packets);
}

fn parse_list(line: &[char]) -> (Packet, &[char]) {
    let mut line = &line[1..];
    let mut contents = Vec::new();

    loop {
        match line[0] {
            ']' => break,
            '[' => {
                let (list, rest) = parse_list(line);
                contents.push(list);
                line = rest;
            }
            ',' => line = &line[1..],
            _ => {
                let (number, rest) = parse_number(line);
                contents.push(number);
                line = rest;
            }
        }
    }

    (Packet::List(contents), &line[1..])
}

fn parse_number(line: &[char]) -> (Packet, &[char]) {
    let mut number = 0;
    let mut i = 0;

    while i < line.len() && line[i].is_numeric() {
        number = number * 10 + line[i].to_digit(10).unwrap() as i32;
        i += 1;
    }

    (Packet::Number(number), &line[i..])
}

fn part1(n: &Input) {
    let sum: usize = n
        .iter()
        .enumerate()
        .map(|(index, (left, right))| if left < right { index + 1 } else { 0 })
        .sum();

    println!("Part 1: {}", sum);
}

fn part2(n: &Input) {
    let mut packets: Vec<Packet> =
        n.iter()
            .fold(Vec::with_capacity(n.len() * 2), |mut acc, (a, b)| {
                acc.push((*a).clone());
                acc.push((*b).clone());
                acc
            });

    let two = parse_list(&"[[2]]".chars().collect::<Vec<_>>()).0;
    let six = parse_list(&"[[6]]".chars().collect::<Vec<_>>()).0;
    packets.push(two.clone());
    packets.push(six.clone());

    packets.sort();

    let two_index = packets.iter().position(|p| p == &two).unwrap() + 1;
    let six_index = packets.iter().position(|p| p == &six).unwrap() + 1;

    println!("Part 2: {}", two_index * six_index);
}
