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
			input:    '1'
			expected: '11'
		},
		Case{
			input:    '11'
			expected: '21'
		},
		Case{
			input:    '21'
			expected: '1211'
		},
		Case{
			input:    '1211'
			expected: '111221'
		},
		Case{
			input:    '111221'
			expected: '312211'
		},
	]

	for case in cases {
		assert round(case.input) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
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

