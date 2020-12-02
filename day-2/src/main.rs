use std::fs;
use std::collections::HashMap;

fn main() { 
    let lines : Vec<String> = fs::read_to_string("./in.in").expect("Smth went wrong smh").split("\n").map(|s| s.to_owned()).collect();
    
    part1(lines.clone());
    part2(lines); 
}

fn part1(n : Vec<String>) {
    let mut valid : u32 = 0;

    for i in n {
        let parts : Vec<String> = i.split(": ").map(|s| s.to_owned()).collect();
        let letter : char = parts[0].split(" ").collect::<Vec<&str>>()[1].to_owned().chars().collect::<Vec<char>>()[0];
        let policy : Vec<u32> = parts[0].split(" ").collect::<Vec<&str>>()[0].split("-").map(|s| s.parse().unwrap()).collect();
        
        let mut count : u32 = 0;
        
        for c in parts[1].chars().collect::<Vec<char>>() {
            if c == letter { count += 1}
        }

        if count >= policy[0] && count <= policy[1] {
            valid += 1;
        }
    }

    println!("{}", valid);
}

fn part2(n : Vec<String>) {
    let mut valid : u32 = 0;

    for i in n {
        let parts : Vec<String> = i.split(": ").map(|s| s.to_owned()).collect();
        let letter : char = parts[0].split(" ").collect::<Vec<&str>>()[1].to_owned().chars().collect::<Vec<char>>()[0];
        let policy : Vec<u32> = parts[0].split(" ").collect::<Vec<&str>>()[0].split("-").map(|s| s.parse().unwrap()).collect();
       
        let chars = parts[1].chars().collect::<Vec<char>>();

        let mut pol_1 : bool = false;
        let mut pol_2 : bool = false;

        for i in 0..chars.len() {
            if policy[0] - 1 == i as u32 && chars[i] == letter {
                pol_1 = true;
            } else if policy[1] - 1 == i as u32 && chars[i] == letter {
                pol_2 = true;
            }
        }
    
        if pol_1 && pol_2 {
        } else if pol_1 {
            valid += 1;
        } else if pol_2 {
            valid += 1;
        }
    }

    println!("{}", valid);
}
