module main

import common
import math

struct Day {
	name string = 'Day '
}

type Grid = [][]bool

fn is_corner(x int, y int, w int, h int) bool {
	return (y == 0 || y == h) && (x == 0 || x == w)
}

fn parse(mut reader common.Reader, corners bool) Grid {
	mut grid := [][]bool{}
	for {
		line := reader.next_line() or { break }
		mut row := []bool{}
		for c in line {
			row << (c == `#`)
		}
		grid << row
	}

	if corners {
		for y in 0 .. grid.len {
			for x in 0 .. grid[0].len {
				grid[y][x] = if is_corner(x, y, grid[0].len - 1, grid.len - 1) {
					true
				} else {
					grid[y][x]
				}
			}
		}
	}

	return grid
}

fn step(grid Grid, corners bool) Grid {
	mut new_grid := [][]bool{len: grid.len, init: []bool{len: grid[0].len}}

	h := grid.len - 1
	w := grid[0].len - 1

	for y in 0 .. h + 1 {
		for x in 0 .. w + 1 {
			if corners && is_corner(x, y, w, h) {
				new_grid[y][x] = true

				continue
			}

			is_on := grid[y][x]

			mut nearby_on := 0

			for dx in math.max(-1, -x) .. math.min(2, w - x + 1) { // non inclusive
				for dy in math.max(-1, -y) .. math.min(2, h - y + 1) { // non inclusive
					if dy == 0 && dx == 0 {
						continue
					}

					if grid[y + dy][x + dx] {
						nearby_on++
					}
				}
			}

			new_grid[y][x] = if is_on { nearby_on in [2, 3] } else { nearby_on == 3 }
		}
	}

	return new_grid
}

fn (d Day) execute(mut reader common.Reader, steps int, corners bool) string {
	mut grid := parse(mut reader, corners)

	for _ in 0 .. steps {
		grid = step(grid, corners)
	}

	mut on := 0
	for row in grid {
		on += row.count(|x| x)
	}

	return on.str()
}

fn (d Day) part_1(mut reader common.Reader) string {
	return d.execute(mut reader, 100, false)
}

fn (d Day) part_2(mut reader common.Reader) string {
	return d.execute(mut reader, 100, true)
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

