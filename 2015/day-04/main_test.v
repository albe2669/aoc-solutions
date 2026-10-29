module main

import common

fn test_part_1() {
	day := Day{}

	assert day.part_1(mut common.create_test_reader('abcdef')) == '609043'
	assert day.part_1(mut common.create_test_reader('pqrstuv')) == '1048970'
}

fn test_part_2() {
	day := Day{}

	assert day.part_2(mut common.create_test_reader('pqrstuv')) == 'implement'
}

