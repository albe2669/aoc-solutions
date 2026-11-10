module main

import common

struct Day {
	name string = 'Day 13'
}

type Graph = map[string]map[string]int

fn parse(line string) (string, string, int) {
	parts := line.split(' ')

	mut happiness := parts[3].int()
	if parts[2] == 'lose' {
		happiness = -happiness
	}

	return parts[0], parts[parts.len - 1].replace('.', ''), happiness
}

fn create_graph(mut reader common.Reader) Graph {
	mut g := map[string]map[string]int{}

	for {
		line := reader.next_line() or { break }
		from, to, happiness := parse(line)

		g[from][to] += happiness
	}

	return g
}

fn weight(g Graph, from string, to string) int {
	return g[from][to] + g[to][from]
}

fn cycle(g Graph) int {
	people := g.keys()
	first := people[0]
	rest := people[1..]

	permutations := common.permutations(rest)

	mut best := -1
	for perm in permutations {
		mut total := 0
		total += weight(g, first, perm[0])
		for i in 0 .. perm.len - 1 {
			total += weight(g, perm[i], perm[i + 1])
		}
		total += weight(g, perm[perm.len - 1], first)

		if best == -1 || total > best {
			best = total
		}
	}

	return best
}

fn (d Day) part_1(mut reader common.Reader) string {
	g := create_graph(mut reader)

	return '${cycle(g)}'
}

fn (d Day) part_2(mut reader common.Reader) string {
	mut g := create_graph(mut reader)
	for person in g.keys() {
		g[person]['Me'] = 0
		g['Me'][person] = 0
	}

	return '${cycle(g)}'
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

