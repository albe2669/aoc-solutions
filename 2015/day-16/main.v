module main

import common

struct Day {
	name string = 'Day 16'
}

struct Sue {
pub mut:
	number     int
	properties map[string]int
}

const known_properties = {
	'children':    3
	'cats':        7
	'samoyeds':    2
	'pomeranians': 3
	'akitas':      0
	'vizslas':     0
	'goldfish':    5
	'trees':       3
	'cars':        2
	'perfumes':    1
}

fn parse_sue(mut reader common.Reader) []Sue {
	mut sues := []Sue{}

	for {
		line := reader.next_line() or { break }

		number := line.all_after('Sue ').all_before(':').int()

		mut properties := map[string]int{}
		for _, prop in line.all_after(': ').split(', ') {
			key, value := prop.split_once(': ') or { continue }

			properties[key] = value.int()
		}

		sues << Sue{
			number:     number
			properties: properties
		}
	}

	return sues
}

fn find_sue(sues []Sue, matches fn (string, int) bool) int {
	outer: for sue in sues {
		for key, value in sue.properties {
			if !matches(key, value) {
				continue outer
			}
		}

		return sue.number
	}

	return -1
}

fn base_case(key string, value int) bool {
	return known_properties[key] == value
}

fn (d Day) part_1(mut reader common.Reader) string {
	sues := parse_sue(mut reader)
	return find_sue(sues, base_case).str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	sues := parse_sue(mut reader)
	return find_sue(sues, fn (key string, value int) bool {
		return match key {
			'cats', 'trees' {
				value > known_properties[key]
			}
			'pomeranians', 'goldfish' {
				value < known_properties[key]
			}
			else {
				base_case(key, value)
			}
		}
	}).str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

