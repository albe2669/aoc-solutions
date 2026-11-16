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
			input:    'Hit Points: 55\nDamage: 8\n'
			expected: '953'
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
			input:    'Hit Points: 55\nDamage: 8\n'
			expected: '1289'
		},
	]

	for case in cases {
		assert day.part_2(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}
