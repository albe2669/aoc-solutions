use std::{env, fs};

type Input = Vec<Vec<char>>;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();
    let chars = lines
        .iter()
        .map(|line| line.chars().collect::<Vec<char>>())
        .collect();

    part1(&chars);
    part2(&chars);
}

fn look_for_chars(chars: &Vec<char>, amount: usize) -> usize {
    for i in amount..chars.len() {
        let mut found = true;
        let slice = &chars[i - amount..i];
        for char in slice.iter() {
            if slice.iter().filter(|c| c == &char).count() > 1 {
                found = false;
                break;
            }
        }
        if found {
            return i;
        }
    }

    0
}

fn part1(n: &Input) {
    for line in n {
        println!("Part 1: {}", look_for_chars(line, 4));
    }
}

fn part2(n: &Input) {
    for line in n {
        println!("Part 2: {}", look_for_chars(line, 14));
    }
}
