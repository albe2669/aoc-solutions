module main

import common

struct Day {
	name string = 'Day 23'
}

fn get_instructions(mut reader common.Reader) [][]string {
	mut instructions := [][]string{}
	for {
		line := reader.next_line() or { break }
		mut split := line.split(' ')
		if split.len == 3 {
			split[1] = split[1].replace(',', '')
		}
		instructions << split
	}

	return instructions
}

fn run(instructions [][]string, mut registers map[string]int) map[string]int {
	mut pc := 0

	for pc >= 0 && pc < instructions.len {
		instruction := instructions[pc]
		register := instruction[1]
		if register !in registers {
			registers[register] = 0
		}

		match instruction[0] {
			'hlf' {
				registers[register] = registers[register] / 2
			}
			'tpl' {
				registers[register] = registers[register] * 3
			}
			'inc' {
				registers[register] = registers[register] + 1
			}
			'jmp' {
				pc += instruction[1].int()
				continue
			}
			'jie' {
				if registers[register] % 2 == 0 {
					pc += instruction[2].int()
					continue
				}
			}
			'jio' {
				if registers[register] == 1 {
					pc += instruction[2].int()
					continue
				}
			} else {
				panic('Unknown instruction: ${instruction[0]}')
			}
		}

		pc++
	}

	return registers
}

fn (d Day) part_1(mut reader common.Reader) string {
	instructions := get_instructions(mut reader)
	mut registers := map[string]int{}
	registers = run(instructions, mut registers)

	return registers['b'].str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	instructions := get_instructions(mut reader)
	mut registers := {'a': 1}
	registers = run(instructions, mut registers)

	return registers['b'].str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

