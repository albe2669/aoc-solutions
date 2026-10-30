module main

import common

struct Case[T] {
	input    string
	expected T
}

fn test_part_1() {
	day := Day{}

	cases := [
		Case{'ugknbfddgicrmopn', '1'},
		Case{'aaa', '1'},
		Case{'jchzalrnumimnmhp', '0'},
		Case{'haegwjzuvuyypxyu', '0'},
		Case{'dvszwmarrgswjxmb', '0'},
	]

	for case in cases {
		assert day.part_1(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}

fn test_part_2() {
	day := Day{}

	cases := [
		Case{'qjhvhtzxzqqjkmpb', '1'},
		Case{'xxyxx', '1'},
		Case{'uurcxstgmygtbstg', '0'},
		Case{'ieodomkazucvgmuy', '0'},
		Case{'aaa', '0'},
		Case{'aaaa', '1'},
		Case{'', '0'},
	]

	for case in cases {
		assert day.part_2(mut common.create_test_reader(case.input)) == case.expected, 'Expected "${case.input}" to result in ${case.expected}'
	}
}
