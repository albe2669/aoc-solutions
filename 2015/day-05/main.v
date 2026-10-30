module main

import common

struct Day {
	name string = 'Day '
}

fn is_p1_nice_string(s string) bool {
	mut vowel_count := 0
	mut has_double := false

	for i, token in s {
		if token in [`a`, `e`, `i`, `o`, `u`] {
			vowel_count++
		}

		if i == s.len - 1 {
			continue
		}

		next_token := s[i + 1]
		if next_token == token {
			has_double = true
		}

		if s[i..i + 2] in ['ab', 'cd', 'pq', 'xy'] {
			return false
		}
	}

	return vowel_count >= 3 && has_double
}

fn (d Day) part_1(mut reader common.Reader) string {
	mut nice_count := 0
	for {
		line := reader.next_line() or { break }
		if is_p1_nice_string(line) {
			nice_count++
		}
	}

	return nice_count.str()
}

fn is_p2_nice_string(s string) bool {
	mut has_pair := false
	mut has_repeat := false

	mut first_seen := map[u16]int{}

	for i, cur in s {
		if !has_pair && i < s.len - 1 {
			key := u16(cur) << 8 | u16(s[i + 1])
			if key in first_seen && first_seen[key] <= i - 2 {
				has_pair = true
			} else if key !in first_seen {
				first_seen[key] = i
			}
		}

		if !has_repeat && i < s.len - 2 {
			has_repeat = cur == s[i + 2]
		}
	}

	return has_pair && has_repeat
}

fn (d Day) part_2(mut reader common.Reader) string {
	mut nice_count := 0
	for {
		line := reader.next_line() or { break }
		if is_p2_nice_string(line) {
			nice_count++
		}
	}

	return nice_count.str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}
