module main

import common
import math

struct Day {
	name string = 'Day 25'
}

fn pos(row u64, col u64) u64 {
   d := row + col - 1
   return d * (d - 1) / 2 + col
}

fn powmod(base u64, exp u64, m u64) u64 {
   mut b := base
   mut e := exp
   mut result := u64(1)
   for e > 0 {
      if e & 1 == 1 {
         result = result * b % m
      }
      b = b * b % m
      e >>= 1
   }
   return result
}

fn code_at(row u64, col u64) u64 {
   return 20151125 * powmod(252533, pos(row, col) - 1, 33554393) % 33554393
}

fn parse_coords(mut reader common.Reader) (u64, u64) {
	line := reader.next_line() or { panic('Failed to read line') }
	parts := line.split(' ')
	row := parts[16].replace(',', '').u64()
	col := parts[18].replace('.', '').u64()

	return row, col
}

fn (d Day) part_1(mut reader common.Reader) string {
	row, col := parse_coords(mut reader)

	return code_at(row, col).str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	return 'implement'
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

