use std::{collections::HashMap, env, fs};

type Input = Vec<()>;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let (blocks, moves) 

    for line in content.lines() {
        let (s1, s2) = line.trim().split_once(',').unwrap();
        pairs.push((parse_range(s1), parse_range(s2)));
    }

    part1(&pairs);
    part2(&pairs);
}

fn part1(n: &Input) {
    println!("Part 1: {}", 1);
}

fn part2(n: &Input) {
    println!("Part 2: {}", 0);
}
