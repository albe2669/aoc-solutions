module common

import os
import cli

pub interface Day {
	name string
	part_1(mut reader Reader) string
	part_2(mut reader Reader) string
}

fn run_part(command cli.Command, part_fn fn (mut reader Reader) string) {
	is_test := command.flags[0].get_bool() or { false }

	input_file := if is_test {
		'test.in'
	} else {
		'input.in'
	}

	if !os.exists(input_file) {
		eprintln('Input file not found: ${input_file}')
		return
	}

	println('Running ${command.name} with input file: ${input_file}')
	file_contents := os.read_file(input_file) or {
		eprintln('Failed to read input file: ${input_file}')
		return
	}

	mut reader := create_test_reader(file_contents)
	result := part_fn(mut reader)
	println('Result: ${result}')
}

pub fn define_and_run_app(day Day) {
	mut app := cli.Command{
		name:        day.name
		description: 'Run the solutions for ${day.name}'
		flags:       [
			cli.Flag{
				flag:        cli.FlagType.bool
				name:        'test'
				abbrev:      't'
				description: 'Whether to run the test input or the real input'
				required:    false
				global:      true
			},
		]
		commands:    [
			cli.Command{
				name:        'p1'
				description: 'Run part 1 of ${day.name}'
				execute:     fn [day] (cmd cli.Command) ! {
					run_part(cmd, day.part_1)
				}
			},
			cli.Command{
				name:        'p2'
				description: 'Run part 2 of ${day.name}'
				execute:     fn [day] (cmd cli.Command) ! {
					run_part(cmd, day.part_2)
				}
			},
		]
	}
	app.setup()
	app.parse(os.args)
}
