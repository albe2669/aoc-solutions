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
			input:    '.#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####..'
			expected: '4'
		},
	]

	for case in cases {
		assert day.execute(mut common.create_test_reader(case.input), 4, false) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

fn test_part_2() {
	day := Day{}

	cases := [
		Case{
			input:    '.#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####..'
			expected: '17'
		},
	]

	for case in cases {
		assert day.execute(mut common.create_test_reader(case.input), 5, true) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

