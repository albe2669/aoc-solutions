module main

import common

struct Case[T] {
	input    string
	expected T
}

fn test_part_1() {
	day := Day{}

	cases := [
		Case{
			input:    '20\n15\n10\n5\n5'
			expected: '4'
		},
	]

	for case in cases {
		assert day.exec(mut common.create_test_reader(case.input), 25, false) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

fn test_part_2() {
	day := Day{}

	cases := [
		Case{
			input:    '20\n15\n10\n5\n5'
			expected: '3'
		},
	]

	for case in cases {
		assert day.exec(mut common.create_test_reader(case.input), 25, true) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}
