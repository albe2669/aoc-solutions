use std::{collections::HashMap, env, fs};

type Input = Vec<((u32, u32), (u32, u32))>;

fn parse_range(range: &str) -> (u32, u32) {
    let (first, second) = range.split_once('-').unwrap();
    (
        first.parse::<u32>().unwrap(),
        second.parse::<u32>().unwrap(),
    )
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let mut pairs: Input = Vec::new();

    for line in content.lines() {
        let (s1, s2) = line.trim().split_once(',').unwrap();
        pairs.push((parse_range(s1), parse_range(s2)));
    }

    part1(&pairs);
    part2(&pairs);
}

fn part1(n: &Input) {
    let mut count = 0;

    for pair in n {
        count += match pair {
            ((a, b), (x, y)) if a <= x && y <= b => 1,
            ((a, b), (x, y)) if x <= a && b <= y => 1,
            _ => 0,
        }
    }

    println!("Part 1: {}", count);
}

fn part2(n: &Input) {
    let mut count = 0;
    for pair in n {
        let ((a, b), (x, y)) = pair;
        count += if std::cmp::max(a, x) <= std::cmp::min(b, y) {
            1
        } else {
            0
        };
    }

    println!("Part 2: {}", count);
}
