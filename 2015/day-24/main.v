module main

import common
import arrays

const not_found = u64(1) << 62

struct Day {
	name string = 'Day 24'
}

struct Search {
	packages []u64
	target   u64
	suffix   []u64
	groups   u64
mut:
	best u64
}

fn parse(mut reader common.Reader) []u64 {
	mut result := []u64{}
	for {
		line := reader.next_line() or { break }
		result << line.u64()
	}
	result.sort(a > b)
	return result
}

fn (mut s Search) dfs(start int, left int, sum u64, prod u64, mask u64) {
	if left == 0 {
		if sum == s.target && prod < s.best && s.splits(mask, s.groups - 1) {
			s.best = prod
		}
		return
	}
	if sum + s.suffix[start] < s.target {
		return
	}
	for i in start .. s.packages.len {
		p := s.packages[i]
		if sum + p > s.target || prod * p >= s.best {
			continue
		}
		s.dfs(i + 1, left - 1, sum + p, prod * p, mask | (u64(1) << i))
	}
}

fn (s Search) splits(used u64, groups u64) bool {
	mut first := -1
	mut rest := u64(0)
	for i, p in s.packages {
		if (used & (u64(1) << i)) == 0 {
			if first < 0 {
				first = i
			}
			rest += p
		}
	}
	if groups == 1 {
		return rest == s.target
	}
	return s.pick_group(used | (u64(1) << first), first + 1, s.packages[first], groups)
}

fn (s Search) pick_group(used u64, start int, sum u64, groups u64) bool {
	if sum == s.target {
		return s.splits(used, groups - 1)
	}
	if sum + s.suffix[start] < s.target {
		return false
	}
	for i in start .. s.packages.len {
		if (used & (u64(1) << i)) != 0 {
			continue
		}
		p := s.packages[i]
		if sum + p > s.target {
			continue
		}
		if s.pick_group(used | (u64(1) << i), i + 1, sum + p, groups) {
			return true
		}
	}
	return false
}

fn find(packages []u64, groups u64) u64 {
	mut total := arrays.sum(packages) or { panic('failed to sum packages') }
	mut suffix := []u64{len: packages.len + 1}
	for i := packages.len - 1; i >= 0; i-- {
		suffix[i] = suffix[i + 1] + packages[i]
	}
	mut s := Search{
		packages: packages
		target:   total / groups
		suffix:   suffix
		groups:   groups
		best:     not_found
	}
	for size in 1 .. packages.len + 1 {
		s.best = not_found
		s.dfs(0, size, 0, 1, 0)
		if s.best != not_found {
			return s.best
		}
	}
	panic('no valid split found')
}

fn (d Day) part_1(mut reader common.Reader) string {
	return find(parse(mut reader), 3).str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	return find(parse(mut reader), 4).str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}
