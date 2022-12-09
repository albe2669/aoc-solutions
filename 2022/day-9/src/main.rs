use std::{collections::HashMap, env, fs};

enum Direction {
    Up,
    Down,
    Left,
    Right,
}

type Input = Vec<(Direction, i32)>;

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
            let (dir, num) = line.trim().split_once(' ').unwrap();
            let num = num.parse::<i32>().unwrap();
            match dir {
                "R" => (Direction::Right, num),
                "L" => (Direction::Left, num),
                "U" => (Direction::Up, num),
                "D" => (Direction::Down, num),
                _ => panic!("Unknown direction"),
            }
        })
        .collect();

    part1(&chars);
    part2(&chars);
}

fn move_head(head: (i32, i32), dir: &Direction) -> (i32, i32) {
    match dir {
        Direction::Up => (head.0, head.1 + 1),
        Direction::Down => (head.0, head.1 - 1),
        Direction::Left => (head.0 - 1, head.1),
        Direction::Right => (head.0 + 1, head.1),
    }
}

fn move_knot(knot: (i32, i32), other: (i32, i32)) -> (i32, i32) {
    let diff_point = (other.0 - knot.0, other.1 - knot.1);
    match diff_point {
        (0, 2) => (knot.0, knot.1 + 1),
        (0, -2) => (knot.0, knot.1 - 1),
        (2, 0) => (knot.0 + 1, knot.1),
        (-2, 0) => (knot.0 - 1, knot.1),
        (1, 2) => (knot.0 + 1, knot.1 + 1),
        (1, -2) => (knot.0 + 1, knot.1 - 1),
        (-1, 2) => (knot.0 - 1, knot.1 + 1),
        (-1, -2) => (knot.0 - 1, knot.1 - 1),
        (2, 1) => (knot.0 + 1, knot.1 + 1),
        (2, -1) => (knot.0 + 1, knot.1 - 1),
        (-2, 1) => (knot.0 - 1, knot.1 + 1),
        (-2, -1) => (knot.0 - 1, knot.1 - 1),
        (2, 2) => (knot.0 + 1, knot.1 + 1),
        (2, -2) => (knot.0 + 1, knot.1 - 1),
        (-2, 2) => (knot.0 - 1, knot.1 + 1),
        (-2, -2) => (knot.0 - 1, knot.1 - 1),
        _ => knot,
    }
}

fn part1(n: &Input) {
    let mut head_pos = (0, 0);
    let mut tail_pos = (0, 0);
    let mut map: HashMap<(i32, i32), bool> = HashMap::new();

    for (dir, num) in n {
        for _ in 0..*num {
            head_pos = move_head(head_pos, dir);
            tail_pos = move_knot(tail_pos, head_pos);

            // Only move the tail if it's outside the 1x of the head
            map.insert(tail_pos, true);
        }
    }

    let mut sum = 0;
    for (pos, _) in map {
        sum += 1;
    }

    println!("Part 1: {}", sum);
}

fn part2(n: &Input) {
    let mut rope = Vec::new();
    for _ in 0..10 {
        rope.push((0, 0));
    }
    let mut map: HashMap<(i32, i32), bool> = HashMap::new();

    for (dir, num) in n {
        for _ in 0..*num {
            rope[0] = move_head(rope[0], dir);
            for i in 1..rope.len() {
                rope[i] = move_knot(rope[i], rope[i - 1]);
            }

            // Only move the tail if it's outside the 1x of the head
            map.insert(rope[rope.len() - 1], true);
        }
    }

    let mut sum = 0;
    for (pos, _) in map {
        sum += 1;
    }

    println!("Part 2: {}", sum);
}
