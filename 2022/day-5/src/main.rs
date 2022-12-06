extern crate regex;

use regex::Regex;
use std::{collections::HashMap, env, fs};

type Input = Vec<()>;

// Parse blocks looking like this:
//     [D]
// [N] [C]
// [Z] [M] [P]
//  1   2   3
fn parse_blocks(input: &[&str]) -> (HashMap<usize, Vec<char>>, usize) {
    let mut blocks = HashMap::new();

    // Parse the numbers line
    let columns = input[input.len() - 1].trim().split_whitespace().count();

    let block_lines = &input[0..input.len() - 1];
    for block_line in block_lines.iter().rev() {
        let chars: Vec<char> = block_line.trim_matches('\n').chars().collect();

        for col in 0..columns {
            let index = col * 4;
            let block = &chars[index..index + 3];

            if block == [' ', ' ', ' '] {
                continue;
            }

            let content = block[1];
            blocks.entry(col + 1).or_insert(Vec::new()).push(content);
        }
    }

    (blocks, columns)
}

fn parse_moves(input: &[&str]) -> Vec<(usize, usize, usize)> {
    let regex =
        Regex::new(r"(?m)move (?P<amount>\d*) from (?P<source>\d) to (?P<destination>\d)").unwrap();
    let mut moves = Vec::new();

    for i in input.iter() {
        println!("{}", i);
        let result = regex.captures(i).unwrap();
        let amount = result["amount"].parse().unwrap();
        let source = result["source"].parse().unwrap();
        let destination = result["destination"].parse().unwrap();

        moves.push((amount, source, destination));
    }

    moves
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();
    let split = lines.splitn(2, |line| line.is_empty()).collect::<Vec<_>>();

    let (mut blocks, columns) = parse_blocks(split[0]);
    let moves = parse_moves(split[1]);

    part1(&mut blocks.clone(), &moves, columns);
    part2(&mut blocks, &moves, columns);
}

fn print_res(blocks: &HashMap<usize, Vec<char>>, columns: usize) {
    let mut line = String::new();
    for col in 1..=columns {
        let column = blocks.get(&col).unwrap();
        line.push(column[column.len() - 1]);
    }

    println!("{}", line);
}

fn part1(
    blocks: &mut HashMap<usize, Vec<char>>,
    moves: &Vec<(usize, usize, usize)>,
    columns: usize,
) {
    for mv in moves.iter() {
        let (amount, source, destination) = mv;

        let elems = {
            let source = blocks.get_mut(source).unwrap();
            let mut elems = Vec::new();
            for _ in 0..*amount {
                elems.push(source.pop().unwrap());
            }
            elems
        };
        let destination = blocks.get_mut(destination).unwrap();
        destination.extend(elems.iter())
    }

    println!("Part 1:");
    print_res(blocks, columns);
}

fn part2(
    blocks: &mut HashMap<usize, Vec<char>>,
    moves: &Vec<(usize, usize, usize)>,
    columns: usize,
) {
    for mv in moves.iter() {
        let (amount, source, destination) = mv;
        let elems = {
            let source = blocks.get_mut(source).unwrap();
            source.split_off(source.len() - amount)
        };

        let destination = blocks.get_mut(destination).unwrap();
        destination.extend(elems.iter())
    }
    println!("Part 2:");
    print_res(blocks, columns);
}
