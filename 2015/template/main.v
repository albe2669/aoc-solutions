module main

import common

struct Day {
	name string = 'Day '
}

fn (d Day) part_1(mut reader common.Reader) string {
	return 'implement'
}

fn (d Day) part_2(mut reader common.Reader) string {
	return 'implement'
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

