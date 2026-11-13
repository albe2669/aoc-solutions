module main

import common

struct Day {
	name string = 'Day '
}

fn (d Day) part_1(mut reader common.Reader) string {
	target := reader.next_int() or { panic("Failed to read input") }

	// presents[house] = total presents delivered to house
	mut presents := []int{len: 1000000 + 1, init: 0}

	for elf in 1 .. presents.len {
		// Each elf delivers presents to every house that is a multiple of their number
		mut house := elf
		for house < presents.len {
			presents[house] += elf * 10
			house += elf
		}
	}

	// Find the first house that meets or exceeds the target number of presents
	for house, present_count in presents {
		if present_count >= target {
			return house.str()
		}
	}


	panic("No house found that meets the target")
}

fn (d Day) part_2(mut reader common.Reader) string {
	target := reader.next_int() or { panic("Failed to read input") }

	// presents[house] = total presents delivered to house
	mut presents := []int{len: 1000000 + 1, init: 0}

	for elf in 1 .. presents.len {
		// Each elf delivers presents to every house that is a multiple of their number
		mut house := elf
		for house < presents.len && house <= elf * 50 {
			presents[house] += elf * 11
			house += elf
		}
	}

	// Find the first house that meets or exceeds the target number of presents
	for house, present_count in presents {
		if present_count >= target {
			return house.str()
		}
	}


	panic("No house found that meets the target")
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

