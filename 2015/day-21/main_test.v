module main

import common

struct Case[T] {
	input    string
	expected T
}

fn test_player_wins() {
	assert player_wins(Entity{hp: 8, damage: 5, armor: 5}, Entity{hp: 12, damage: 7, armor: 2})
	assert !player_wins(Entity{hp: 8, damage: 5, armor: 5}, Entity{hp: 12, damage: 7, armor: 5})
}

fn test_part_1() {
	day := Day{}

	cases := [
		Case{
			input:    'Hit Points: 12\nDamage: 7\nArmor: 2\n'
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
			input:    'Hit Points: 100\nDamage: 100\nArmor: 100\n'
			expected: '356'
		},
	]

	for case in cases {
		assert day.part_2(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}
