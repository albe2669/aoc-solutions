module main

import common

fn test_part_1() {
	day1 := Day1{}

	assert day1.part_1(mut common.create_test_reader('(())')) == '0'
	assert day1.part_1(mut common.create_test_reader('()()')) == '0'
	assert day1.part_1(mut common.create_test_reader('(((')) == '3'
	assert day1.part_1(mut common.create_test_reader('(()(()(')) == '3'
	assert day1.part_1(mut common.create_test_reader('))(((((')) == '3'
	assert day1.part_1(mut common.create_test_reader('())')) == '-1'
	assert day1.part_1(mut common.create_test_reader('))(')) == '-1'
	assert day1.part_1(mut common.create_test_reader(')))')) == '-3'
	assert day1.part_1(mut common.create_test_reader(')())())')) == '-3'
}

fn test_part_2() {
	day1 := Day1{}

	assert day1.part_2(mut common.create_test_reader(')')) == '1'
	assert day1.part_2(mut common.create_test_reader('()())')) == '5'
}

