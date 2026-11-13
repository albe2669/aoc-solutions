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
			input:    '10'
			expected: '1'
		},
		Case{
			input:    '30'
			expected: '2'
		},
		Case{
			input:    '40'
			expected: '3'
		},
		Case{
			input:    '70'
			expected: '4'
		},
		Case{
			input:    '60'
			expected: '4'
		},
		Case{
			input:    '120'
			expected: '6'
		},
		Case{
			input:    '80'
			expected: '6'
		},
		Case{
			input:    '150'
			expected: '8'
		},
		Case{
			input:    '130'
			expected: '8'
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

