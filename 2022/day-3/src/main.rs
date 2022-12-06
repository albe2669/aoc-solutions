use std::{collections::HashMap, env, fs};

type Input = Vec<Vec<char>>;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let mut plays: Input = Vec::new();

    for line in content.lines() {
        let s: Vec<char> = line.trim().chars().collect();
        plays.push(s);
    }

    part1(&plays);
    part2(&plays);
}

fn get_prio(c: char) -> u64 {
    match c {
        'A'..='Z' => c as u64 - 38,
        'a'..='z' => c as u64 - 96,
        _ => panic!("Unsupported character: {}", c),
    }
}

fn part1(n: &Input) {
    let mut sum = 0;

    for pack in n {
        let mut map = HashMap::new();
        let (first, second) = pack.split_at(pack.len() / 2);

        for c in first.iter() {
            map.insert(c, true);
        }

        for c in second.iter() {
            if map.contains_key(c) {
                sum += get_prio(*c);
                break;
            }
        }
    }

    println!("Part 1: {}", sum);
}

fn part2(n: &Input) {
    let mut sum = 0;
    let mut map = HashMap::new();

    for (i, pack) in n.iter().enumerate() {
        if i % 3 == 0 {
            map = HashMap::new();
        }

        for c in pack.iter() {
            match i % 3 {
                0 => {
                    map.insert(c, false);
                }
                1 => {
                    if let Some(v) = map.get_mut(c) {
                        println!("Pack contains {}, it's value is {}", c, v);
                        *v = true
                    }
                }
                2 => {
                    if let Some(v) = map.get(c) {
                        if !(*v) {
                            continue;
                        }

                        println!("Pack contains {}, it's value is {}", c, v);
                        sum += get_prio(*c);
                        break;
                    }
                }
                v => panic!("Too many packs: {}", v),
            }
        }
    }

    println!("Part 2: {}", sum);
}
