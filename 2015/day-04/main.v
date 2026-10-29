module main

import common
import crypto.md5

struct Day {
	name string = 'Day 4'
}

struct WorkIterator {
	chunk_size int
mut:
	start int
}

pub fn (mut iter WorkIterator) next() ?int {
	// one job is the start of a chunk; the worker hashes chunk_size numbers
	// from it, so the whole range is covered without a second field
	max := 2147483647
	if iter.start >= max {
		return none
	}
	job := iter.start
	iter.start += iter.chunk_size
	return job
}

fn calc(mut reader common.Reader, prefix string) int {
	input := reader.next_line() or { return -1 }

	chunk_size := 10_000
	mut pool := common.new_pool(4, fn [input, prefix, chunk_size] (start int) ?int {
		for i in start .. start + chunk_size {
			hash := md5.hexhash('${input}${i}')
			if hash.starts_with(prefix) {
				return i
			}
		}
		return none
	})
	mut iter := WorkIterator{
		chunk_size: chunk_size
	}
	return pool.work(mut iter) or { return -1 }
}

fn (d Day) part_1(mut reader common.Reader) string {
	return calc(mut reader, '00000').str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	return calc(mut reader, '000000').str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

