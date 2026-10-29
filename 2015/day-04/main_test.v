module main

import common

fn test_part_1() {
	day := Day{}

	assert day.part_1(mut common.create_test_reader('abcdef')) == '609043'
	assert day.part_1(mut common.create_test_reader('pqrstuv')) == '1048970'
	assert day.part_1(mut common.create_test_reader('ckczppom')) == '117946'
}

fn test_part_2() {
	day := Day{}

	assert day.part_2(mut common.create_test_reader('abcdef')) == '6742839'
	assert day.part_2(mut common.create_test_reader('pqrstuv')) == '5714438'
	assert day.part_2(mut common.create_test_reader('ckczppom')) == '3938038'
}

