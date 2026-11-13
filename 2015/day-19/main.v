module main

import common
import datatypes
import rand

struct Day {
	name string = 'Day '
}

fn parse(mut reader common.Reader) (map[string][]string, string) {
	mut replacements := map[string][]string{}
	mut molecule := ''
	for {
		line := reader.next_line() or { break }
		if line == '' {
			continue
		}
		if line.contains('=>') {
			parts := line.split(' => ')
			replacements[parts[0]] << parts[1]
		} else {
			molecule = line
		}
	}
	return replacements, molecule
}

fn do_replacements(replacements map[string][]string, molecule string) datatypes.Set[string] {
	mut results := datatypes.Set[string]{}

	for i := 0; i < molecule.len; i++ {
		for key, values in replacements {
			if molecule[i..].starts_with(key) {
				for value in values {
					new_molecule := molecule[..i] + value + molecule[i + key.len..]
					results.add(new_molecule)
				}
			}
		}
	}

	return results
}

fn (d Day) part_1(mut reader common.Reader) string {
	replacements, molecule := parse(mut reader)
	results := do_replacements(replacements, molecule)
	return results.size().str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	replacements, mut molecule := parse(mut reader)

	mut reverse_replacements := map[string][]string{}
	for key, values in replacements {
		for value in values {
			reverse_replacements[value] << key
		}
	}

	values := reverse_replacements.keys()

	for attempt := 0; attempt < 100000; attempt++ {
		mut m := molecule
		mut steps := 0
		for m != 'e' {
			mut applied := false
			for ri in 0 .. values.len {
				value := values[(ri + (rand.intn(values.len) or { 0 })) % values.len]
				start_idx := m.index(value) or { continue }
				m = m[..start_idx] + reverse_replacements[value][0] + m[start_idx + value.len..]
				steps++
				applied = true
				break
			}
			if !applied {
				break
			}
		}
		if m == 'e' {
			return steps.str()
		}
	}

	return 'No solution found'
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

