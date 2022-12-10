use std::{env, fs};

#[derive(Clone, Debug)]
enum Operation {
    Addx(i32),
    Aaddx(i32),
    Nop,
    NextOp(usize),
}

type Input = Vec<Operation>;

struct CPU {
    ops: Vec<Operation>,
    stack: Vec<Operation>,
    x: i32,
    cycle: i32,
    done: bool,
}

impl CPU {
    fn new(n: &Input) -> Self {
        let mut c = Self {
            ops: n.clone(),
            stack: Vec::new(),
            x: 1,
            cycle: 1,
            done: false,
        };

        c.stack.push(Operation::NextOp(0));
        c
    }

    fn simulate_cycle(&mut self) {
        let op = self.stack.pop().unwrap();
        self.cycle += 1;

        match op {
            Operation::Nop => (),
            Operation::Addx(_) => panic!("Addx should not be on the stack"),
            Operation::Aaddx(v) => self.x += v,
            Operation::NextOp(i) => {
                self.cycle -= 1;
                let new_op = self.ops.get(i as usize);
                match new_op {
                    Some(Operation::Addx(x)) => {
                        self.stack.push(Operation::NextOp(i + 1));
                        self.stack.push(Operation::Aaddx(*x));
                        self.stack.push(Operation::Nop);
                    }
                    Some(v) => {
                        self.stack.push(Operation::NextOp(i + 1));
                        self.stack.push(v.clone());
                    }
                    None => {
                        self.done = true;
                        return;
                    }
                }

                self.simulate_cycle();
            }
        }
    }
}

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
    let mut cpu = CPU::new(n);
    let mut sum = 0;

    while !cpu.done {
        match [20, 60, 100, 140, 180, 220]
            .iter()
            .find(|&&x| x == cpu.cycle)
        {
            Some(v) => sum += cpu.x * v,
            None => (),
        };

        cpu.simulate_cycle();
    }

    println!("Part 1: {}", sum);
}

fn part2(n: &Input) {
    let mut cpu = CPU::new(n);
    let mut rows: Vec<Vec<char>> = Vec::new();
    let mut current_row = -1;

    while !cpu.done {
        let crt_location = (cpu.cycle - 1) % 40;
        if crt_location == 0 {
            rows.push(vec!['\u{2591}'; 40]);
            current_row += 1;
        }
        if crt_location == cpu.x - 1 || crt_location == cpu.x + 1 || crt_location == cpu.x {
            rows[current_row as usize][crt_location as usize] = '\u{2588}';
        }

        cpu.simulate_cycle();
    }

    println!("Part 2:");
    for row in rows {
        println!("{}", row.iter().collect::<String>());
    }
}
