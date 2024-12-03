use std::{collections::HashMap, collections::VecDeque, env, fs};

#[derive(Debug, Clone)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

#[derive(Debug, Clone, Eq, Hash, PartialEq)]
struct Position {
    x: u32,
    y: u32,
}

impl Position {
    fn new(x: usize, y: usize) -> Position {
        Position {
            x: x as u32,
            y: y as u32,
        }
    }

    fn newt(x: i32, y: i32) -> Position {
        Position {
            x: x as u32,
            y: y as u32,
        }
    }
}

#[derive(Debug, Clone)]
struct Blizzard {
    position: Position,
    direction: Direction,
}

impl Blizzard {
    fn new(dir: Direction, x: usize, y: usize) -> Self {
        Self {
            position: Position::new(x, y),
            direction: dir,
        }
    }

    fn move_blizzard(&mut self, width: u32, height: u32) {
        match self.direction {
            Direction::Up => self.position.y -= 1,
            Direction::Down => self.position.y += 1,
            Direction::Left => self.position.x -= 1,
            Direction::Right => self.position.x += 1,
        }

        match (self.position.x, self.position.y) {
            (0, _) => self.position.x = width - 2,
            (_, 0) => self.position.y = height - 2,
            (x, _) if x == width - 1 => self.position.x = 1,
            (_, y) if y == height - 1 => self.position.y = 1,
            _ => (),
        }
    }
}

#[derive(Debug, Clone)]
struct MapPoint {
    blizzards: Vec<Blizzard>,
    is_wall: bool,
}

impl MapPoint {
    fn is_steppable(&self) -> bool {
        !self.is_wall && self.blizzards.is_empty()
    }
}

type Map = HashMap<Position, MapPoint>;
type Timeline = Vec<Map>;

fn get_start_and_end(lines: &Vec<&str>) -> (Position, Position) {
    let mut start = Position::new(0, 0);
    let mut end = Position::new(0, 0);

    for (x, c) in lines[0].chars().enumerate() {
        if c == '.' {
            start = Position::new(x, 0);
        }
    }

    let y = lines.len() - 1;
    for (x, c) in lines[y].chars().enumerate() {
        if c == '.' {
            end = Position::new(x, y);
        }
    }

    (start, end)
}

fn parse_map(lines: &Vec<&str>) -> Map {
    let mut map: Map = HashMap::new();

    for (y, line) in lines[0..lines.len()].iter().enumerate() {
        for (x, c) in line.chars().enumerate() {
            let pos = Position::new(x, y);

            let blizzard = match c {
                '>' => Some(Blizzard {
                    direction: Direction::Right,
                    position: pos.clone(),
                }),
                '<' => Some(Blizzard {
                    direction: Direction::Left,
                    position: pos.clone(),
                }),
                '^' => Some(Blizzard {
                    direction: Direction::Up,
                    position: pos.clone(),
                }),
                'v' => Some(Blizzard {
                    direction: Direction::Down,
                    position: pos.clone(),
                }),
                _ => None,
            };

            map.insert(
                pos,
                MapPoint {
                    blizzards: blizzard.map_or(Vec::new(), |b| vec![b]),
                    is_wall: c == '#',
                },
            );
        }
    }

    map
}

fn gen_timeline(map: &Map, width: u32, height: u32) -> Timeline {
    let mut timeline: Timeline = vec![HashMap::new(); 1000]; // Increase if not enough
    timeline[0] = map.clone();

    for i in 1..timeline.len() {
        let earlier = timeline[i - 1].clone();

        for (posi, mapi) in earlier.iter() {
            // Update the wall status on new map
            timeline[i]
                .entry(posi.clone())
                .or_insert(MapPoint {
                    blizzards: Vec::new(),
                    is_wall: false,
                })
                .is_wall = mapi.is_wall;

            for blizzard in &mapi.blizzards {
                let mut blizzard = blizzard.clone();
                blizzard.move_blizzard(width, height);

                timeline[i]
                    .entry(blizzard.position.clone())
                    .or_insert(MapPoint {
                        blizzards: Vec::new(),
                        is_wall: false, // Will be updated later
                    })
                    .blizzards
                    .push(blizzard);
            }
        }
    }

    timeline
}

fn path_find(
    map: &Timeline,
    start: Position,
    end: Position,
    start_time: u32,
    width: u32,
    height: u32,
) -> u32 {
    let mut queue = VecDeque::new();
    let mut visited = HashMap::new();

    queue.push_back((start_time, start.clone()));
    visited.insert((start_time, start), true);

    while !queue.is_empty() {
        let (current_t, current_pos) = queue.pop_front().unwrap();
        let next_t = current_t + 1 as u32;
        println!("{}: {:?}", next_t, current_pos);
        print_map(&map[next_t as usize], width, height);

        for (x_off, y_off) in &[(-1, 0), (1, 0), (0, -1), (0, 1), (0, 0)] {
            if current_pos.x as i32 + x_off < 0 || current_pos.y as i32 + y_off < 0 {
                continue;
            }

            let next_pos =
                Position::newt(current_pos.x as i32 + x_off, current_pos.y as i32 + y_off);

            if next_pos.x == end.x && next_pos.y == end.y {
                return next_t;
            }

            let next_on_map = map[next_t as usize].get(&next_pos);
            if next_on_map.is_none() {
                continue;
            }
            if next_on_map.unwrap().is_steppable()
                && !visited.contains_key(&(next_t, next_pos.clone()))
            {
                queue.push_back((next_t, next_pos.clone()));
                visited.insert((next_t, next_pos), true);
            }
        }
    }

    9999999
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.get(1).is_none() {
        panic!("Supply a file to run against");
    }

    let content = fs::read_to_string(args.get(1).unwrap()).expect("Reading file went wrong");
    let lines: Vec<&str> = content.lines().collect();
    let (start, end) = get_start_and_end(&lines);
    let blizzards = parse_map(&lines);

    let width = lines[0].len() as u32;
    let height = lines.len() as u32;

    let timeline = gen_timeline(&blizzards, width, height);

    println!("Start: {:?}", start);
    println!("End: {:?}", end);

    let mut minute_sum = 0;
    minute_sum += path_find(&timeline, start.clone(), end.clone(), 0, width, height);

    println!("Part 1: {}", minute_sum);
    minute_sum += path_find(
        &timeline,
        end.clone(),
        start.clone(),
        minute_sum,
        width,
        height,
    );
    println!("Part 2: {}", minute_sum - 1);
    //minute_sum += path_find(&timeline, start, end, minute_sum);

    println!("Part 2: {}", minute_sum);
}

fn print_map(map: &Map, width: u32, height: u32) {
    for y in 0..height {
        for x in 0..width {
            let pos = Position { x, y };
            let point = map.get(&pos).unwrap();

            if point.is_wall {
                print!("#");
            } else if point.blizzards.len() == 1 {
                match point.blizzards[0].direction {
                    Direction::Up => print!("^"),
                    Direction::Down => print!("v"),
                    Direction::Left => print!("<"),
                    Direction::Right => print!(">"),
                }
            } else if point.blizzards.len() > 1 {
                print!("{}", point.blizzards.len());
            } else {
                print!(".");
            }
        }
        println!();
    }
}
