module main

import common
import strings

struct Day {
	name string = 'Day 10'
}

fn round(input string) string {
	mut builder := strings.new_builder(input.len * 2)
	mut count := 1

	for i, c in input {
		if i + 1 < input.len && input[i + 1] == c {
			count++
		} else {
			builder.write_string('${count.str()}${c.ascii_str()}')
			count = 1
		}
	}

	return builder.str()
}

fn calc(mut reader common.Reader, rounds int) string {
	mut line := reader.next_line() or { panic('No input') }

	for _ in 0 .. rounds {
		line = round(line)
	}

	return line.len.str()
}

fn (d Day) part_1(mut reader common.Reader) string {
	return calc(mut reader, 40)
}

fn (d Day) part_2(mut reader common.Reader) string {
	return calc(mut reader, 50)
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

