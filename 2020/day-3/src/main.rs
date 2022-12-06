use std::fs;
use std::collections::HashMap;

fn main() { 
    let lines = fs::read_to_string("./in.in").expect("Smth went wrong smh");
    
    part1(lines.clone());
    part2(lines); 
}

fn part1(n : String) {
    println!("Part 1: {}", work(n, 3, 1));
}

fn part2(n : String) {
    let mut trees : usize = 1;
    
    trees *= work(n.clone(), 1, 1);
    trees *= work(n.clone(), 3, 1);
    trees *= work(n.clone(), 5, 1);
    trees *= work(n.clone(), 7, 1);
    trees *= work(n.clone(), 1, 2);

    println!("Part 2: {}", trees);
}

fn work(n : String, xd : usize, yd : usize) -> usize {
    return n
        .lines()
        .step_by(yd)
        .zip((0..).step_by(xd))
        .filter(|&(line, i)| line.chars().cycle().nth(i).unwrap() == '#')
        .count();
}
