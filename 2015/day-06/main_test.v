module main

import common

struct Case[T] {
	input    string
	expected T
}

fn test_part_1() {
	day := Day{}

	cases := [
		Case{'turn on 0,0 through 999,999', '1000000'},
		Case{'toggle 0,0 through 999,0', '1000'},
		Case{'turn off 499,499 through 500,500', '0'},
	]

	for case in cases {
		assert day.part_1(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

fn test_part_2() {
	day := Day{}

	cases := [
		Case{'turn on 0,0 through 0,0', '1'},
		Case{'toggle 0,0 through 999,999', '2000000'},
	]

	for case in cases {
		assert day.part_2(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

