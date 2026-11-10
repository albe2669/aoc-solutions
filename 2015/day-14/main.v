module main

import common
import math
import arrays

struct Day {
	name string = 'Day 14'
}

struct Reindeer {
pub mut:
	speed    int
	duration int
	rest     int
	points   int
}

fn parse_reindeer(mut reader common.Reader) []&Reindeer {
	mut reindeer := []&Reindeer{}

	for {
		line := reader.next_line() or { break }

		parts := line.split(' ')
		speed := parts[3].int()
		duration := parts[6].int()
		rest := parts[13].int()

		reindeer << &Reindeer{
			speed:    speed
			duration: duration
			rest:     rest
		}
	}

	return reindeer
}

fn (r &Reindeer) distance_flown(seconds int) int {
	cycle_len := r.duration + r.rest
	full_cycles := seconds / cycle_len
	incomplete_cycle_time := math.min(seconds % cycle_len, r.duration)

	return full_cycles * r.speed * r.duration + incomplete_cycle_time * r.speed
}

fn (d Day) distance_flown(mut reader common.Reader, seconds int) string {
	mut best_distance := 0

	for r in parse_reindeer(mut reader) {
		best_distance = math.max(best_distance, r.distance_flown(seconds))
	}

	return best_distance.str()
}

fn (d Day) part_1(mut reader common.Reader) string {
	return d.distance_flown(mut reader, 2503)
}

fn (d Day) points(mut reader common.Reader, seconds int) string {
	mut reindeer := parse_reindeer(mut reader)

	for i in 1 .. seconds + 1 {
		distances := reindeer.map(it.distance_flown(i))
		max_distance := arrays.max(distances) or { 0 }

		for r, distance in distances {
			if distance == max_distance {
				reindeer[r].points++
			}
		}
	}

	mut max_points := 0
	for r in reindeer {
		max_points = math.max(max_points, r.points)
	}

	return max_points.str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	return d.points(mut reader, 2503)
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}
