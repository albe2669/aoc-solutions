module main

import common

struct Day {
	name string = 'Day 07'
}

interface Gate {
	common.Hashable
	apply(inputs map[string]u16) u16
	str() string
}

struct AssignGate {
mut:
	id    int
	value u16
	name  string
}

fn (g AssignGate) apply(wires map[string]u16) u16 {
	if g.name != '' {
		return wires[g.name] or { panic('AssignGate: input wire ${g.name} not found') }
	}
	return g.value
}

fn (g &AssignGate) hash() int {
	return g.id
}

fn (g AssignGate) str() string {
	return if g.name != '' { g.name } else { '${g.value}' }
}

struct NotGate {
mut:
	id    int
	input string
}

fn (g NotGate) apply(wires map[string]u16) u16 {
	input_value := wires[g.input] or { panic('NotGate: input wire ${g.input} not found') }
	return input_value ^ 0xFFFF
}

fn (g &NotGate) hash() int {
	return g.id
}

fn (g NotGate) str() string {
	return 'NOT ${g.input}'
}

struct OpGate {
mut:
	id    int
	left  string
	right string
	op    string
}

fn is_literal(token string) bool {
	return token.len > 0 && token[0] >= `0` && token[0] <= `9`
}

fn operand_value(token string, wires map[string]u16) u16 {
	if is_literal(token) {
		return token.u16()
	}
	return wires[token] or { panic('OpGate: wire ${token} not found') }
}

fn (g OpGate) apply(wires map[string]u16) u16 {
	left_value := operand_value(g.left, wires)
	right_value := operand_value(g.right, wires)

	return match g.op {
		'AND' { left_value & right_value }
		'OR' { left_value | right_value }
		'LSHIFT' { left_value << right_value }
		'RSHIFT' { left_value >> right_value }
		else { panic('OpGate: unknown operation ${g.op}') }
	}
}

fn (g &OpGate) hash() int {
	return g.id
}

fn (g OpGate) str() string {
	return '${g.left} ${g.op} ${g.right}'
}

struct GateDeps {
	gate   Gate
	inputs []string
}

fn parse_input(mut reader common.Reader) (common.Graph[Gate, string], map[string][]string) {
	mut graph := common.new_graph[Gate, string]()

	mut gate_outputs := map[string][]string{}
	mut drivers := map[string]Gate{}
	mut deps := []GateDeps{}
	mut next_id := 1

	for {
		line := reader.next_line() or { break }

		split := line.split(' -> ')
		instruction := split[0]
		output := split[1]

		split_instruction := instruction.split(' ')

		record := fn (mut drivers map[string]Gate, mut gate_outputs map[string][]string, mut deps []GateDeps, output string, gate Gate, inputs []string) {
			drivers[output] = gate
			gate_outputs[gate.str()] << output
			deps << GateDeps{
				gate:   gate
				inputs: inputs
			}
		}

		if split_instruction.len == 1 {
			token := split_instruction[0]
			mut assign := if is_literal(token) {
				AssignGate{
					value: token.u16()
				}
			} else {
				AssignGate{
					name: token
				}
			}
			assign.id = next_id
			next_id++

			mut inputs := []string{}
			if !is_literal(token) {
				inputs << token
			}
			record(mut drivers, mut gate_outputs, mut deps, output, assign, inputs)
		} else if split_instruction.len == 2 {
			if split_instruction[0] != 'NOT' {
				panic('Unknown operation: ${split_instruction[0]}')
			}
			mut not_gate := NotGate{
				input: split_instruction[1]
			}
			not_gate.id = next_id
			next_id++

			record(mut drivers, mut gate_outputs, mut deps, output, not_gate,
				[split_instruction[1]])
		} else if split_instruction.len == 3 {
			mut op_gate := OpGate{
				left:  split_instruction[0]
				right: split_instruction[2]
				op:    split_instruction[1]
			}
			op_gate.id = next_id
			next_id++

			mut inputs := []string{}
			if !is_literal(op_gate.left) {
				inputs << op_gate.left
			}
			if !is_literal(op_gate.right) {
				inputs << op_gate.right
			}
			record(mut drivers, mut gate_outputs, mut deps, output, op_gate, inputs)
		} else {
			panic('Unknown instruction format: ${instruction}')
		}
	}

	for d in deps {
		graph.add_node(d.gate)
		for input in d.inputs {
			source := drivers[input] or { panic('no driver for wire ${input}') }
			graph.add_edge(source, d.gate, input)
		}
	}

	return graph, gate_outputs
}

fn calculate_wire_values(mut graph common.Graph[Gate, string], gate_outputs map[string][]string) map[string]u16 {
	mut wire_values := map[string]u16{}

	order := graph.topo_sort() or { panic('Graph has a cycle') }

	for gate in order {
		value := gate.apply(wire_values)
		for output in gate_outputs[gate.str()] or { []string{} } {
			wire_values[output] = value
		}
	}

	return wire_values
}

fn (d Day) part_1(mut reader common.Reader) string {
	mut graph, gate_outputs := parse_input(mut reader)

	wire_values := calculate_wire_values(mut graph, gate_outputs)

	return wire_values['a'].str()
}

// Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire a). What new signal is ultimately provided to wire a?

fn (d Day) part_2(mut reader common.Reader) string {
	input := reader.all_string() or { panic('part_2: no input') }

	mut r1 := common.create_test_reader(input)
	mut graph, gate_outputs := parse_input(mut r1)
	first := calculate_wire_values(mut graph, gate_outputs)['a']

	// Override the signal of b with the result of part 1, then recompute.
	mut lines := []string{}
	for line in input.split_into_lines() {
		if line.ends_with('-> b') {
			continue
		}
		lines << line
	}
	lines << '${first} -> b'

	mut r2 := common.create_test_reader(lines.join('\n'))
	mut graph2, gate_outputs2 := parse_input(mut r2)
	return calculate_wire_values(mut graph2, gate_outputs2)['a'].str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

