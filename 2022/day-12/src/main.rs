use std::{
    cmp::Reverse,
    collections::{BTreeMap, BinaryHeap},
    env, fs,
};

fn get_height(c: char) -> i32 {
    match c {
        'S' => 0,
        'E' => get_height('z'),
        _ => c as i32 - 97,
    }
}

type Vertex = (usize, usize);
type Edge = i32;
type Graph = BTreeMap<Vertex, BTreeMap<Vertex, Edge>>;

fn add_edge(graph: &mut Graph, v1: Vertex, v2: Vertex, e: Edge) {
    graph.entry(v1).or_insert_with(BTreeMap::new).insert(v2, e);
}

// All credit for this goes to: https://github.com/TheAlgorithms/Rust/blob/master/src/graph/dijkstra.rs
pub fn dijkstra(graph: &Graph, start: &Vertex) -> BTreeMap<Vertex, Option<(Vertex, Edge)>> {
    let mut ans = BTreeMap::new();
    let mut prio = BinaryHeap::new();

    // start is the special case that doesn't have a predecessor
    ans.insert(*start, None);

    for (new, weight) in &graph[start] {
        ans.insert(*new, Some((*start, *weight)));
        prio.push(Reverse((*weight, new, start)));
    }

    while let Some(Reverse((dist_new, new, prev))) = prio.pop() {
        match ans[new] {
            // what we popped is what is in ans, we'll compute it
            Some((p, d)) if p == *prev && d == dist_new => {}
            // otherwise it's not interesting
            _ => continue,
        }

        for (next, weight) in &graph[new] {
            match ans.get(next) {
                // if ans[next] is a lower dist than the alternative one, we do nothing
                Some(Some((_, dist_next))) if dist_new + *weight >= *dist_next => {}
                // if ans[next] is None then next is start and so the distance won't be changed, it won't be added again in prio
                Some(None) => {}
                // the new path is shorter, either new was not in ans or it was farther
                _ => {
                    ans.insert(*next, Some((*new, *weight + dist_new)));
                    prio.push(Reverse((*weight + dist_new, next, new)));
                }
            }
        }
    }

    ans
}

type Input = Graph;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();
    let chars = lines
        .iter()
        .map(|l| l.chars().collect::<Vec<char>>())
        .collect::<Vec<Vec<char>>>();

    let mut graph = Graph::new();
    let mut start = (0, 0);
    let mut end = (0, 0);
    let mut a = Vec::new();

    for y in 0..chars.len() {
        for x in 0..chars[0].len() {
            let mut c = chars[y][x];
            if c == 'S' {
                start = (x, y);
                c = 'a';
            } else if c == 'E' {
                end = (x, y);
                c = 'z';
            }

            if c == 'a' {
                a.push((x, y));
            }

            let height = get_height(c);
            if x != 0 && get_height(chars[y][x - 1]) <= height + 1 {
                add_edge(&mut graph, (x, y), (x - 1, y), 1);
            }
            if y != 0 && get_height(chars[y - 1][x]) <= height + 1 {
                add_edge(&mut graph, (x, y), (x, y - 1), 1);
            }
            if x != chars[0].len() - 1 && get_height(chars[y][x + 1]) <= height + 1 {
                add_edge(&mut graph, (x, y), (x + 1, y), 1);
            }
            if y != chars.len() - 1 && get_height(chars[y + 1][x]) <= height + 1 {
                add_edge(&mut graph, (x, y), (x, y + 1), 1);
            }
        }
    }

    part1(&graph, start, end);
    part2(&graph, end, a);
}

fn part1(n: &Input, start: Vertex, end: Vertex) {
    let distances = dijkstra(n, &start);
    println!("Part 1: {:?}", distances.get(&end).unwrap().unwrap().1);
}

fn part2(n: &Input, end: Vertex, a: Vec<Vertex>) {
    let mut shortest = std::i32::MAX;

    for pos in a {
        let distances = dijkstra(n, &pos);
        if let Some(Some((_, d))) = distances.get(&end) {
            if *d < shortest {
                shortest = *d;
            }
        }
    }

    println!("Part 2: {}", shortest);
}
