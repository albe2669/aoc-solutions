module main

import common

fn test_part_1() {
	day := Day2{}

	assert day.part_1(mut common.create_test_reader('2x3x4')) == '58'
	assert day.part_1(mut common.create_test_reader('1x1x10')) == '43'
}

fn test_part_2() {
	day := Day2{}

	assert day.part_2(mut common.create_test_reader('2x3x4')) == '34'
	assert day.part_2(mut common.create_test_reader('1x1x10')) == '14'
}

