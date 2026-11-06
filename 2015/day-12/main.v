module main

import common
import x.json2

struct Day {
	name string = 'Day 12'
}

fn walk_json(value json2.Any, skip string) int {
	mut sum := 0

	match value {
		[]json2.Any {
			for item in value {
				sum += walk_json(item, skip)
			}
		}
		map[string]json2.Any {
			mut has_skip := false
			for _, item in value {
				if skip != '' && item is string && item == skip {
					has_skip = true
				}
			}
			if !has_skip {
				for _, item in value {
					sum += walk_json(item, skip)
				}
			}
		}
		f64 {
			sum += int(value)
		}
		else {}
	}

	return sum
}

fn parse_and_walk_json(data string, skip string) int {
	parsed_json := json2.decode[json2.Any](data) or { panic('Failed to parse JSON: $err') }
	return walk_json(parsed_json, skip)
}

fn (d Day) part_1(mut reader common.Reader) string {
	line := reader.next_line() or { panic('Failed to read line') }

	return parse_and_walk_json(line, '').str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	line := reader.next_line() or { panic('Failed to read line') }

	return parse_and_walk_json(line, 'red').str()
}


fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

