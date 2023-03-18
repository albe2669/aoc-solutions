use std::{collections::HashMap, env, fs};

#[derive(Clone)]
enum Operation {
    Add(u64),
    Multiply(u64),
    Exponent(),
}

#[derive(Clone)]
struct Monkey {
    number: u64,
    items: Vec<u64>,
    operation: Operation,
    test: u64,
    test_true: u64,
    test_false: u64,
    inspected: u64,
}

impl Monkey {
    fn print(&self) {
        println!("monkey: {}", self.number);
        println!("items: {:?}", self.items);
        println!("test: {:?}", self.test);
        println!("test_true: {:?}", self.test_true);
        println!("test_false: {:?}", self.test_false);
    }

    fn take_turn(&mut self, divide: bool, lcm: u64) -> HashMap<u64, Vec<u64>> {
        let mut map = HashMap::new();

        while !self.items.is_empty() {
            self.inspected += 1;

            let item = self.items.pop().unwrap();
            let mut item_value = match self.operation {
                Operation::Add(x) => item + x,
                Operation::Multiply(x) => item * x,
                Operation::Exponent() => item.pow(2),
            };

            if divide {
                item_value = (item_value as f64 / 3f64).floor() as u64;
            } else {
                item_value %= lcm;
            }

            if item_value % self.test == 0 {
                map.entry(self.test_true)
                    .or_insert(Vec::new())
                    .push(item_value);
            } else {
                map.entry(self.test_false)
                    .or_insert(Vec::new())
                    .push(item_value);
            }
        }

        map
    }
}

type Input = Vec<Monkey>;

// Parse input of the type:
// Monkey 0:
//  Starting items: 79, 98
//  Operation: new = old * 19
//  Test: divisible by 23
//    If true: throw to monkey 2
//    If false: throw to monkey 3
fn parse(lines: Vec<String>) -> Monkey {
    let monkey_num = lines[0]
        .trim()
        .strip_prefix("Monkey ")
        .unwrap()
        .strip_suffix(':')
        .unwrap()
        .parse::<u64>()
        .unwrap();

    let items = lines[1]
        .trim()
        .strip_prefix("Starting items: ")
        .unwrap()
        .split(", ")
        .map(|x| x.parse::<u64>().unwrap())
        .collect();

    let op_line = lines[2].clone();
    let op_slice = op_line
        .trim()
        .strip_prefix("Operation: new = ")
        .unwrap()
        .split(' ')
        .collect::<Vec<&str>>();

    let op = (op_slice[0], op_slice[1], op_slice[2].parse::<u64>());

    let operation = match op {
        ("old", "*", Err(_)) => Operation::Exponent(),
        ("old", "*", Ok(x)) => Operation::Multiply(x),
        ("old", "+", Ok(x)) => Operation::Add(x),
        _ => panic!("Invalid operation"),
    };

    let test = lines[3]
        .trim()
        .strip_prefix("Test: divisible by ")
        .unwrap()
        .parse::<u64>()
        .unwrap();

    let test_true = lines[4]
        .trim()
        .strip_prefix("If true: throw to monkey ")
        .unwrap()
        .parse::<u64>()
        .unwrap();
    let test_false = lines[5]
        .trim()
        .strip_prefix("If false: throw to monkey ")
        .unwrap()
        .parse::<u64>()
        .unwrap();

    Monkey {
        number: monkey_num,
        items,
        operation,
        test,
        test_true,
        test_false,
        inspected: 0,
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();
    let monkeys = lines
        .split(|x| x.is_empty())
        .map(|x| parse(x.iter().map(|x| x.to_string()).collect()))
        .collect::<Vec<Monkey>>();

    part1(monkeys.clone());
    part2(monkeys);
}

fn simulate(mut monkeys: Input, rounds: usize, divide: bool) -> Input {
    let lcm = monkeys.iter().map(|x| x.test).product();
    for _ in 0..rounds {
        for m in 0..monkeys.len() {
            let monkey = &mut monkeys[m];
            let map = monkey.take_turn(divide, lcm);

            for (k, v) in map {
                monkeys[k as usize].items.extend(v);
            }
        }
    }

    monkeys
}

fn part1(mut n: Input) {
    n = simulate(n, 20, false);

    // Get the 2 monkeys with the most inspected
    n.sort_by_key(|x| x.inspected);
    let most_inspected = n[(n.len() - 2)..n.len()]
        .iter()
        .map(|x| x.inspected)
        .product::<u64>();

    println!("Part 1: {:?}", most_inspected);
}

fn part2(mut n: Input) {
    n = simulate(n, 10000, false);

    // Get the 2 monkeys with the most inspected
    n.sort_by_key(|x| x.inspected);
    let most_inspected = n[(n.len() - 2)..n.len()]
        .iter()
        .map(|x| x.inspected)
        .product::<u64>();

    println!("Part 1: {:?}", most_inspected);
}
