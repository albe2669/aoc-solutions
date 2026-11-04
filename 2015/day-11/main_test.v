module main

import common

struct Case[T] {
	input    string
	expected T
}

fn test_part_1() {
	day := Day{}

	pass_cases := [
		Case{
			input:    'hijklmmn'
			expected: false
		},
		Case{
			input:    'abbceffg'
			expected: false
		},
		Case{
			input:    'abbcegjk'
			expected: false
		},
	]

	for case in pass_cases {
		assert is_valid_pass(case.input) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}

	cases := [
		Case{
			input:    'abcdefgh'
			expected: 'abcdffaa'
		},
		Case{
			input:    'ghijklmn'
			expected: 'ghjaabcc'
		},
	]

	for case in cases {
		assert day.part_1(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

fn test_part_2() {
	day := Day{}

	pass_cases := [
		Case{
			input:    ''
			expected: 'implement'
		},
	]

	for case in pass_cases {
		assert day.part_2(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

