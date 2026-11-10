module main

import common
import math

struct Day {
	name string = 'Day 15'
}

const teaspoon_count = 100
const part_2_calories = 500

fn parse_ingredients(mut reader common.Reader) [][]int {
	mut ingredients := [][]int{}
	for {
		line := reader.next_line() or { break }
		parts := line.split(' ')

		ingredients << [
			parts[2].trim_right(',').int(),
			parts[4].trim_right(',').int(),
			parts[6].trim_right(',').int(),
			parts[8].trim_right(',').int(),
			parts[10].int(),
		]
	}
	return ingredients
}

fn calculate_score(ingredients [][]int, calorie_flag bool) int {
	mut max_score := 0

	for i in 0 .. teaspoon_count {
		for j in 0 .. teaspoon_count {
			if i + j > teaspoon_count {
				break
			}
			for k in 0 .. teaspoon_count {
				l := teaspoon_count - i - j - k
				if l < 0 {
					break
				}

				count := [i, j, k, l]

				mut res := [0, 0, 0, 0, 0]
				for t, ingredient in ingredients {
					for u in 0 .. 5 {
						res[u] += ingredient[u] * count[t]
					}
				}

				if calorie_flag && res[4] != part_2_calories {
					continue
				}

				for u in 0 .. 4 {
					if res[u] < 0 {
						res[u] = 0
					}
				}
				max_score = math.max(max_score, res[0] * res[1] * res[2] * res[3])
			}
		}
	}

	return max_score
}

fn exec(mut reader common.Reader, calorie_flag bool) string {
	ingredients := parse_ingredients(mut reader)

	return calculate_score(ingredients, calorie_flag).str()
}

fn (d Day) part_1(mut reader common.Reader) string {
	return exec(mut reader, false)
}

fn (d Day) part_2(mut reader common.Reader) string {
	return exec(mut reader, true)
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}
