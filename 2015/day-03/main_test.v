module main

import common

fn test_part_1() {
	day := Day3{}

	assert day.part_1(mut common.create_test_reader('>')) == '2'
	assert day.part_1(mut common.create_test_reader('^>v<')) == '4'
	assert day.part_1(mut common.create_test_reader('^v^v^v^v^v')) == '2'
}

fn test_part_2() {
	day := Day3{}

	assert day.part_2(mut common.create_test_reader('^v')) == '3'
	assert day.part_2(mut common.create_test_reader('^>v<')) == '3'
	assert day.part_2(mut common.create_test_reader('^v^v^v^v^v')) == '11'
}

