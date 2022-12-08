use std::{env, fs};

type Input = Vec<Vec<u32>>;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();
    let chars = lines
        .iter()
        .map(|line| {
            line.chars()
                .map(|ch| ch.to_digit(10).unwrap())
                .collect::<Vec<u32>>()
        })
        .collect();

    part1(&chars);
    part2(&chars);
}

fn check_visibility(input: &Input, x: usize, y: usize) -> bool {
    let target = input[y][x];
    // Loop in all directions to find the edge without hitting a tree that is larger than target
    for x_offset in -1..=1 {
        for y_offset in -1..=1 {
            if x_offset == 0 && y_offset == 0 {
                continue;
            }
            let mut x = x as i32 + x_offset;
            let mut y = y as i32 + y_offset;
            // Don't go diagonally
            if x_offset != 0 && y_offset != 0 {
                continue;
            }

            let mut res = true;
            while x >= 0 && y >= 0 && y < input.len() as i32 && x < input[y as usize].len() as i32 {
                if input[y as usize][x as usize] >= target {
                    res = false;
                    break;
                }
                x += x_offset;
                y += y_offset;
            }

            if res {
                return true;
            }
        }
    }

    false
}

fn part1(n: &Input) {
    // Init count to the perimeter
    let mut count = 2 * n.len() + 2 * n[0].len() - 4;
    println!("Perimeter: {}", count);

    for y in 1..(n.len() - 1) {
        for x in 1..(n[y].len() - 1) {
            if check_visibility(n, x, y) {
                println!("Found a peak at {}, {}, {}", y, x, n[y][x]);
                count += 1;
            }
        }
    }
    println!("Part 1: {}", count);
}

fn check_scenic_score(input: &Input, x: usize, y: usize) -> u32 {
    let target = input[y][x];
    // Loop in all directions to find the edge without hitting a tree that is larger than target
    let mut res = 1;

    for x_offset in -1..=1 {
        for y_offset in -1..=1 {
            if x_offset == 0 && y_offset == 0 {
                continue;
            }
            let mut x = x as i32 + x_offset;
            let mut y = y as i32 + y_offset;
            // Don't go diagonally
            if x_offset != 0 && y_offset != 0 {
                continue;
            }

            let mut trees = 0;
            while x >= 0 && y >= 0 && y < input.len() as i32 && x < input[y as usize].len() as i32 {
                trees += 1;
                if input[y as usize][x as usize] >= target {
                    break;
                }
                x += x_offset;
                y += y_offset;
            }
            res *= trees;
        }
    }

    res
}

fn part2(n: &Input) {
    // Init count to the perimeter
    let mut highest = 0;

    for y in 1..(n.len() - 1) {
        for x in 1..(n[y].len() - 1) {
            let score = check_scenic_score(n, x, y);
            if score > highest {
                println!("Found a peak at {}, {}, {} score: {}", y, x, n[y][x], score);
                highest = score;
            }
        }
    }
    println!("Part 2: {}", highest);
}
