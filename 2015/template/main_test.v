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
			input:    ''
			expected: 'implement'
		},
	]

	for case in cases {
		assert day.part_1(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

fn test_part_2() {
	day := Day{}

	cases := [
		Case{
			input:    ''
			expected: 'implement'
		},
	]

	for case in cases {
		assert day.part_2(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

