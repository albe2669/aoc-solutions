module main

import common

struct Day {
	name string = 'Day 09'
}

fn parse_input(mut reader common.Reader) map[string]map[string]int {
	mut distances := map[string]map[string]int{}

	for {
		line := reader.next_line() or { break }
		parts := line.split(' ')
		from := parts[0]
		to := parts[2]
		distance := parts[4].int()

		if from !in distances {
			distances[from] = map[string]int{}
		}
		if to !in distances {
			distances[to] = map[string]int{}
		}

		distances[from][to] = distance
		distances[to][from] = distance
	}

	return distances
}

fn shortest_path_that_visits_all_cities(distances map[string]map[string]int) int {
	cities := distances.keys()
	mut shortest_distance := -1

	for perm in common.permutations(cities) {
		mut total_distance := 0
		for i in 0 .. perm.len - 1 {
			total_distance += distances[perm[i]][perm[i + 1]]
		}
		if shortest_distance == -1 || total_distance < shortest_distance {
			shortest_distance = total_distance
		}
	}

	return shortest_distance
}

fn (d Day) part_1(mut reader common.Reader) string {
	distances := parse_input(mut reader)

	shortest_distance := shortest_path_that_visits_all_cities(distances)
	return '${shortest_distance}'
}

fn longest_path_that_visits_all_cities(distances map[string]map[string]int) int {
	cities := distances.keys()
	mut longest_distance := -1

	for perm in permutations(cities) {
		mut total_distance := 0
		for i in 0 .. perm.len - 1 {
			total_distance += distances[perm[i]][perm[i + 1]]
		}
		if total_distance > longest_distance {
			longest_distance = total_distance
		}
	}

	return longest_distance
}

fn (d Day) part_2(mut reader common.Reader) string {
	distances := parse_input(mut reader)

	longest_distance := longest_path_that_visits_all_cities(distances)
	return '${longest_distance}'
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

