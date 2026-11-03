module main

import common

struct Day {
	name string = 'Day 08'
}

fn count(input string) (int, int) {
	mut code_count := 0
	mut memory_count := 0

	mut should_skip_to := -1

	for i, c in input {
		code_count++
		if i < should_skip_to {
			continue
		}

		if i == 0 || i == input.len - 1 {
			continue
		}

		if c != `\\` {
			memory_count++
			continue
		}

		if i + 1 >= input.len {
			continue
		}

		next := input[i + 1]
		if next == `\\` || next == `"` {
			memory_count++
			should_skip_to = i + 2
			continue
		}

		if next == `x` {
			if i + 3 < input.len {
				should_skip_to = i + 4
				memory_count++
				continue
			}
		}
	}

	return code_count, memory_count
}

fn (d Day) part_1(mut reader common.Reader) string {
	mut code_count := 0
	mut memory_count := 0

	for {
		line := reader.next_line() or { break }
		code, memory := count(line)
		code_count += code
		memory_count += memory
	}

	return '${code_count - memory_count}'
}

fn (d Day) part_2(mut reader common.Reader) string {
	mut code_count := 0

	for {
		line := reader.next_line() or { break }
		code, _ := count(line)

		sanitized_line := '"' + line.replace_each(['\\', '\\\\', '"', '\\"']) + '"'
		san_code, _ := count(sanitized_line)

		code_count += san_code - code
	}

	return '${code_count}'
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

