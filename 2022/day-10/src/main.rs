use std::{cell::RefCell, collections::HashMap, env, fs, process::exit, rc::Rc};

enum Operation {
    Addx(i32),
    Nop,
}

type Input = Vec<Operation>;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();
    let mut instructions: Vec<Operation> = Vec::new();

    for line in lines {
        match line.trim().split_once(' ') {
            Some(("noop", _)) => instructions.push(Operation::Nop),
            None => instructions.push(Operation::Nop),
            Some(("addx", x)) => instructions.push(Operation::Addx(x.parse::<i32>().unwrap())),
            v => panic!("Unknown instruction: {}, {:?}", line, v),
        }
    }

    part1(&instructions);
    part2(&instructions);
}

fn part1(n: &Input) {
    let mut sum = 0;
    let mut x = 1;
    let mut current_cycle = 0;
    let mut current_op = 0;
    let mut current_op_rem = 0;

    while current_op < n.len() {
        current_cycle += 1;
        match [20, 60, 100, 140, 180, 220]
            .iter()
            .find(|&&x| x == current_cycle)
        {
            Some(v) => sum += x * v,
            None => (),
        };

        match n[current_op] {
            Operation::Nop => {
                current_op += 1;
            }
            Operation::Addx(_) if current_op_rem == 0 => {
                current_op_rem = 1;
            }
            Operation::Addx(v) if current_op_rem == 1 => {
                x += v;
                current_op_rem = 0;
                current_op += 1;
            }
            _ => panic!("Unknown operation, {}", current_op),
        }
    }

    println!("Part 1: {}", sum);
}

fn part2(n: &Input) {
    let mut rows: Vec<Vec<char>> = Vec::new();
    let mut x: i32 = 1;
    let mut current_row = -1;
    let mut current_cycle = 0;
    let mut current_op = 0;
    let mut current_op_rem = 0;

    while current_op < n.len() {
        current_cycle += 1;

        let crt_location = (current_cycle - 1) % 40;
        if crt_location == 0 {
            rows.push(vec!['\u{2591}'; 40]);
            current_row += 1;
        }
        if crt_location == x - 1 || crt_location == x + 1 || crt_location == x {
            rows[current_row as usize][crt_location as usize] = '\u{2588}';
        }

        match n[current_op] {
            Operation::Nop => {
                current_op += 1;
            }
            Operation::Addx(_) if current_op_rem == 0 => {
                current_op_rem = 1;
            }
            Operation::Addx(v) if current_op_rem == 1 => {
                x += v;
                current_op_rem = 0;
                current_op += 1;
            }
            _ => panic!("Unknown operation, {}", current_op),
        }
    }

    for row in rows {
        println!("{}", row.iter().collect::<String>());
    }
}
