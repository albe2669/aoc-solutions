module main

import common
import crypto.md5

struct Day {
	name string = 'Day 4'
}

fn calc(mut reader common.Reader, prefix string) int {
	input := reader.next_line() or { return -1 }

	mut i := 0
	for {
		hash := md5.hexhash('${input}${i}')
		if hash.starts_with(prefix) {
			return i
		}
		i++
	}
	return -1
}

fn (d Day) part_1(mut reader common.Reader) string {
	return calc(mut reader, '00000').str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	return calc(mut reader, '000000').str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

