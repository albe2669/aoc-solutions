use std::fs;

fn main() { 
    let lines : Vec<i64> = fs::read_to_string("./in.in").expect("Smth went wrong smh").split_whitespace().map(|s| s.parse().unwrap()).collect();
    
    part1(&lines);
    part2(&lines); 
}

fn part1(n : &Vec<i64>) {
    for i in n.iter() {
        let target = &(2020 - i);
        
        for j in n.iter() {
            if j == target {
                println!("Part 1: {} * {} = {}", i, j, i * j);
                return;
            }
        }
    }
}

fn part2(n : &Vec<i64>) {
    for i in n.iter() {
        for j in n.iter() {
            if i == j { continue; }

            let target = &(2020 - i - j);

            for k in n.iter() {
                if k == target {
                    println!("Part 2: {} * {} * {} = {}", i, j, k, i * j * k);
                    return;
                }
            }
        }
    }
}
