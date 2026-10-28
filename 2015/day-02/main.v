module main

import common
import math

struct Day2 {
	name string = 'Day 2'
}

struct Gift {
	l int
	w int
	h int
}

fn load_input(mut reader common.Reader) !Gift {
	l := reader.next_int()!
	reader.next_byte()!
	w := reader.next_int()!
	reader.next_byte()!
	h := reader.next_int()!
	reader.next_byte() or { 0 }

	return Gift{
		l: l
		w: w
		h: h
	}
}

fn (d Day2) part_1(mut reader common.Reader) string {
	mut total := 0
	for {
		g := load_input(mut reader) or { break }

		s1 := g.l * g.w
		s2 := g.w * g.h
		s3 := g.h * g.l

		smallest := math.min(s1, math.min(s2, s3))
		total += (2 * (s1 + s2 + s3) + smallest)
	}

	return total.str()
}

fn (d Day2) part_2(mut reader common.Reader) string {
	mut total := 0
	for {
		g := load_input(mut reader) or { break }

		total += math.min(g.l + g.w, math.min(g.w + g.h, g.h + g.l)) * 2

		total += g.l * g.w * g.h
	}

	return total.str()
}

fn main() {
	day := Day2{
		name: 'Day 2'
	}
	common.define_and_run_app(day)
}

