module main

import common

struct Day {
	name string = 'Day '
}

struct Grid {
mut:
	lights [][]u32
}

fn new_grid(width int, height int) Grid {
	return Grid{
		lights: [][]u32{len: height, init: []u32{len: width}}
	}
}

type Applier = fn (u32) u32

fn (mut g Grid) apply_to_grid(applier Applier, x1 u32, y1 u32, x2 u32, y2 u32) {
	for y in y1 .. y2 + 1 {
		for x in x1 .. x2 + 1 {
			g.lights[y][x] = applier(g.lights[y][x])
		}
	}
}

fn (g Grid) count_values() u32 {
	mut count := u32(0)
	for row in g.lights {
		for light in row {
			count += light
		}
	}
	return count
}

fn parse_coordinates(coord string) (u32, u32) {
	parts := coord.split(',')
	return parts[0].u32(), parts[1].u32()
}

fn do(mut reader common.Reader, on_action Applier, off_action Applier, toggle_action Applier) string {
	mut grid := new_grid(1000, 1000)

	for {
		line := reader.next_line() or { break }

		parts := line.split(' ')
		match parts[0] {
			'turn' {
				x1, y1 := parse_coordinates(parts[2])
				x2, y2 := parse_coordinates(parts[4])
				if parts[1] == 'on' {
					grid.apply_to_grid(on_action, x1, y1, x2, y2)
				} else if parts[1] == 'off' {
					grid.apply_to_grid(off_action, x1, y1, x2, y2)
				}
			}
			'toggle' {
				x1, y1 := parse_coordinates(parts[1])
				x2, y2 := parse_coordinates(parts[3])
				grid.apply_to_grid(toggle_action, x1, y1, x2, y2)
			}
			else {}
		}
	}

	return grid.count_values().str()
}

fn (d Day) part_1(mut reader common.Reader) string {
	return do(mut reader, fn (_ u32) u32 {
		return 1
	}, fn (_ u32) u32 {
		return 0
	}, fn (v u32) u32 {
		if v == 0 {
			return 1
		} else {
			return 0
		}
	})
}

fn (d Day) part_2(mut reader common.Reader) string {
	return do(mut reader, fn (v u32) u32 {
		return v + 1
	}, fn (v u32) u32 {
		return if v > 0 { v - 1 } else { 0 }
	}, fn (v u32) u32 {
		return v + 2
	})
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

