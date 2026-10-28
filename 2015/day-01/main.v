module main

import common

struct Day1 {
	name string = 'Day 1'
}

fn (d Day1) part_1(mut reader common.Reader) string {
	mut floor := 0

	for {
		next := reader.next_byte() or { break }
		match next {
			`(` { floor++ }
			`)` { floor-- }
			else {}
		}
	}

	return floor.str()
}

fn (d Day1) part_2(mut reader common.Reader) string {
	mut floor := 0
	mut position := 1

	for {
		next := reader.next_byte() or { break }
		match next {
			`(` { floor++ }
			`)` { floor-- }
			else {}
		}

		if floor < 0 {
			return position.str()
		}
		position++
	}

	return 'not found'
}

fn main() {
	day1 := Day1{
		name: 'Day 1'
	}
	common.define_and_run_app(day1)
}

