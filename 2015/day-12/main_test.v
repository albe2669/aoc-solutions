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
			input:    '[1,2,3]'
			expected: '6'
		},
		Case{
			input:    '{"a":2,"b":4}'
			expected: '6'
		},
		Case{
			input:    '[[[3]]]'
			expected: '3'
		},
		Case{
			input:    '{"a":{"b":4},"c":-1}'
			expected: '3'
		},
		Case{
			input:    '{"a":[-1,1]}'
			expected: '0'
		},
		Case{
			input:    '[-1,{"a":1}]'
			expected: '0'
		},
		Case{
			input:    '[]'
			expected: '0'
		},
		Case{
			input:    '{}'
			expected: '0'
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
			input:    '[1,2,3]'
			expected: '6'
		},
		Case{
			input:    '[1,{"c":"red","b":2},3]'
			expected: '4'
		},
		Case{
			input:    '{"d":"red","e":[1,2,3,4],"f":5}'
			expected: '0'
		},
		Case{
			input:    '[1,"red",5]'
			expected: '6'
		},
	]

	for case in cases {
		assert day.part_2(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

