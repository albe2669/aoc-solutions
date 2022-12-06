use std::{env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let mut plays: Vec<(char, char)> = Vec::new();

    for line in content.lines() {
        let s: Vec<char> = line.trim().chars().collect();
        plays.push((s[0], s[2]));
    }

    part1(&plays);
    part2(&plays);
}

fn get_score(play: (char, char)) -> u64 {
    let acs = match play.1 {
        'X' => 1,
        'Y' => 2,
        'Z' => 3,
        _ => panic!("Unsupported action: {}", play.1),
    };

    acs + match play {
        ('A', 'X') => 3,
        ('A', 'Y') => 6,
        ('A', 'Z') => 0,
        ('B', 'X') => 0,
        ('B', 'Y') => 3,
        ('B', 'Z') => 6,
        ('C', 'X') => 6,
        ('C', 'Y') => 0,
        ('C', 'Z') => 3,
        _ => 0,
    }
}

fn part1(n: &Vec<(char, char)>) {
    let mut score = 0;
    for play in n {
        score += get_score(*play)
    }

    println!("Part 1: {}", score);
}

fn get_action(play: (char, char)) -> char {
    match play {
        ('A', 'X') => 'Z', // Lose
        ('A', 'Y') => 'X', // Draw
        ('A', 'Z') => 'Y', // Win
        ('B', 'X') => 'X', // Lose
        ('B', 'Y') => 'Y', // Draw
        ('B', 'Z') => 'Z', // Win
        ('C', 'X') => 'Y', // Lose
        ('C', 'Y') => 'Z', // Draw
        ('C', 'Z') => 'X', // Win
        _ => '0',
    }
}

fn part2(n: &Vec<(char, char)>) {
    let mut score = 0;
    for play in n {
        score += get_score((play.0, get_action(*play)))
    }

    println!("Part 2: {}", score);
}
