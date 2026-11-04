module main

import common

struct Day {
	name string = 'Day 11'
}

fn is_valid_pass(pass string) bool {
	// Check for increasing straight of at least three letters
	mut has_straight := false

	mut has_pairs := false
	mut pairs := map[u16]int{}

	for i, c in pass {
		if !has_straight && i < pass.len - 2 && c + 1 == pass[i + 1]
			&& pass[i + 1] + 1 == pass[i + 2] {
			has_straight = true
		}

		// Check for invalid characters
		if c in [`i`, `o`, `l`] {
			return false
		}

		if !has_pairs && i < pass.len - 1 {
			if pass[i] == pass[i + 1] {
				// Ensure pairs are not overlapping
				if i == 0 || pass[i - 1] != c {
					pairs[u16(c) << 8 | u16(pass[i + 1])] = i
				}

				if pairs.len >= 2 {
					has_pairs = true
				}
			}
		}
	}

	return has_straight && has_pairs
}

fn increment_pass(pass string) string {
	mut pass_bytes := pass.bytes()
	mut i := pass_bytes.len - 1

	for i >= 0 {
		if pass_bytes[i] == `z` {
			pass_bytes[i] = `a`
			i--
		} else {
			pass_bytes[i]++
			break
		}
	}

	return pass_bytes.bytestr()
}

fn get_next_valid_pass(pass string) string {
	mut next_pass := increment_pass(pass)

	for !is_valid_pass(next_pass) {
		next_pass = increment_pass(next_pass)
	}

	return next_pass
}

fn (d Day) part_1(mut reader common.Reader) string {
	mut pass := reader.next_line() or { panic('No input') }

	return get_next_valid_pass(pass)
}

fn (d Day) part_2(mut reader common.Reader) string {
	mut pass := reader.next_line() or { panic('No input') }

	return get_next_valid_pass(get_next_valid_pass(pass))
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

