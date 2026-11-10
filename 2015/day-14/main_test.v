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
			input:    'Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.\nDancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.'
			expected: '1120'
		},
	]

	for case in cases {
		assert day.distance_flown(mut common.create_test_reader(case.input), 1000) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

fn test_part_2() {
	day := Day{}

	cases := [
		Case{
			input:    'Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.\nDancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.'
			expected: '689'
		},
	]

	for case in cases {
		assert day.points(mut common.create_test_reader(case.input), 1000) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

