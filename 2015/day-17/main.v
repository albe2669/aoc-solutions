module main

import common

struct Day {
	name string = 'Day 17'
}

fn parse(mut reader common.Reader) []int {
	mut result := []int{}
	for {
		result << (reader.next_line() or { break }).int()
	}
	return result
}

fn count_fills(containers []int, level int, left int, used int, mut counts []int) {
	if left == 0 {
		counts[used]++
		return
	}
	if level == containers.len {
		return
	}
	count_fills(containers, level + 1, left, used, mut counts)
	if containers[level] <= left {
		count_fills(containers, level + 1, left - containers[level], used + 1, mut counts)
	}
}

fn (d Day) exec(mut reader common.Reader, target int, minimal_only bool) string {
	containers := parse(mut reader)
	mut counts := []int{len: containers.len + 1}
	count_fills(containers, 0, target, 0, mut counts)

	if minimal_only {
		for n in counts {
			if n > 0 {
				return n.str()
			}
		}
		return '0'
	}
	mut total := 0
	for n in counts {
		total += n
	}
	return total.str()
}

fn (d Day) part_1(mut reader common.Reader) string {
	return d.exec(mut reader, 150, false)
}

fn (d Day) part_2(mut reader common.Reader) string {
	return d.exec(mut reader, 150, true)
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}
