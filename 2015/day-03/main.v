module main

import common

struct Day3 {
	name string = 'Day 3'
}

struct Point {
mut:
	x int
	y int
}

pub fn (p Point) hash() int {
	return p.x * 10000 + p.y
}

pub fn (p Point) move(c rune) Point {
	mut new_point := p
	match c {
		`^` { new_point.y++ }
		`v` { new_point.y-- }
		`<` { new_point.x-- }
		`>` { new_point.x++ }
		else {}
	}

	return new_point
}

pub fn (p Point) str() string {
	return '(${p.x}, ${p.y})'
}

fn (d Day3) part_1(mut reader common.Reader) string {
	mut p := Point{0, 0}
	mut m := common.new_hash_map[Point, int]()
	m.set(p, 1)

	for {
		c := reader.next_rune() or { break }
		p = p.move(c)

		m.map_or_default(p, fn (value int) int {
			return value + 1
		}, 1)
	}

	return m.len().str()
}

fn (d Day3) part_2(mut reader common.Reader) string {
	mut points := [Point{0, 0}, Point{0, 0}]

	mut m := common.new_hash_map[Point, int]()
	m.set(points[0], 1)

	mut counter := 0

	for {
		index := counter % 2

		c := reader.next_rune() or { break }
		points[index] = points[index].move(c)

		m.map_or_default(points[index], fn (value int) int {
			return value + 1
		}, 1)

		counter++
	}

	return m.len().str()
}

fn main() {
	day := Day3{}
	common.define_and_run_app(day)
}

