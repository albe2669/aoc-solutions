use std::{cmp, collections::BinaryHeap, env, fs};

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");

    let mut heap: BinaryHeap<i64> = BinaryHeap::new();
    let mut sum = 0;

    for line in content.lines() {
        let s = line.trim();

        if s.is_empty() {
            heap.push(sum);
            sum = 0;
            continue;
        }

        sum += s.parse::<i64>().unwrap();
    }

    part1(&heap);
    part2(&mut heap);
}

fn part1(n: &BinaryHeap<i64>) {
    println!("Part 1: {}", n.peek().unwrap());
}

fn part2(n: &mut BinaryHeap<i64>) {
    println!(
        "Part 2: {}",
        n.pop().unwrap() + n.pop().unwrap() + n.pop().unwrap()
    );
}
