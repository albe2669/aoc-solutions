use std::{cell::RefCell, collections::HashMap, env, fs, rc::Rc};

struct Directory {
    name: String,
    files: Vec<File>,
    parent: Option<Rc<RefCell<Directory>>>,
    directories: HashMap<String, Rc<RefCell<Directory>>>,
    size: usize,
}

struct File {
    name: String,
    size: usize,
}

impl Directory {
    pub fn new(name: String) -> Directory {
        Directory {
            name,
            files: Vec::new(),
            parent: None,
            directories: HashMap::new(),
            size: 0,
        }
    }

    pub fn add_dir(&mut self, new_dir: Rc<RefCell<Directory>>) {
        let bor = new_dir.clone();
        self.directories.insert(bor.borrow().name.clone(), new_dir);
    }

    pub fn add_file(&mut self, new_file: File) {
        self.add_size(new_file.size);
        self.files.push(new_file);
    }

    pub fn add_size(&mut self, size: usize) {
        self.size += size;

        match &self.parent {
            None => (),
            Some(parent) => parent.borrow_mut().add_size(size),
        }
    }

    pub fn print(&self, indent: String) {
        println!("{}- {} (dir, size={})", indent, self.name, self.size);

        self.directories
            .iter()
            .for_each(|(_, value)| (*value).borrow().print(format!("{}  ", indent)));

        self.files
            .iter()
            .for_each(|f| f.print(format!("{}  ", indent)));
    }
}

impl File {
    pub fn print(&self, indent: String) {
        println!("{}- {} (file, size={})", indent, self.name, self.size);
    }
}

type Input = Rc<RefCell<Directory>>;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();

    let root = Rc::new(RefCell::new(Directory::new("/".to_owned())));
    let mut curr_dir = Rc::clone(&root);

    for mut line in lines {
        line = line.trim();

        if line.starts_with("$ cd") {
            let current_clone = Rc::clone(&curr_dir);

            curr_dir = match line.strip_prefix("$ cd ").unwrap() {
                "/" => (root).clone(),
                ".." => current_clone.borrow().parent.as_ref().unwrap().clone(),
                dir => current_clone.borrow().directories.get(dir).unwrap().clone(),
            }
        } else if line.starts_with("$ ls") {
            ()
        } else if line.starts_with("dir") {
            let child = Rc::new(RefCell::new(Directory::new(
                line.strip_prefix("dir ").unwrap().to_owned(),
            )));
            curr_dir.borrow_mut().add_dir((child).clone());
            {
                let mut mut_child = child.borrow_mut();
                mut_child.parent = Some((curr_dir).clone())
            }
        } else {
            let (size, name) = line.split_once(' ').unwrap();
            let child = File {
                name: name.to_owned(),
                size: size.parse().unwrap(),
            };
            curr_dir.borrow_mut().add_file(child);
        }
    }

    root.borrow().print("".to_owned());

    part1(&root);
    part2(&root);
}

fn traverse(n: &Input) -> usize {
    let mut size = 0;
    n.borrow().directories.values().for_each(|value| {
        let child = value.borrow();
        if child.size < 100000 {
            size += child.size;
        }
        size += traverse(value);
    });

    size
}

fn part1(n: &Input) {
    println!("Part 1: {}", traverse(n));
}

fn traverse2(n: &Input, target: usize, curr: usize) -> usize {
    let mut val = curr;
    n.borrow().directories.values().for_each(|value| {
        let child = value.borrow();
        if child.size > target && child.size < val {
            val = child.size;
        }

        val = traverse2(value, target, val);
    });

    val
}

fn part2(n: &Input) {
    // 70000000
    // 30000000
    let b = n.borrow();
    let target = 30000000 - (70000000 - b.size);
    println!("Part 2: {}", traverse2(n, target, b.size))
}
