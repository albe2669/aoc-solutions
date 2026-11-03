// This code is based on the V graph implementation from the stdlib, with modifications to support generic types for nodes and edges.
module common

struct End[V, E] {
pub:
	to    V
	label E
}

pub struct Graph[V, E] {
pub mut:
	nodes HashMap[V, bool]
	edges HashMap[V, []End[V, E]]
}

pub fn new_graph[V, E]() Graph[V, E] {
	return Graph[V, E]{
		nodes: new_hash_map[V, bool]()
		edges: new_hash_map[V, []End[V, E]]()
	}
}

pub fn (mut g Graph[V, E]) add_node(v V) {
	g.nodes.set(v, true)
}

pub fn (mut g Graph[V, E]) add_edge(from V, to V, label E) {
	g.add_node(from)
	g.add_node(to)
	mut ends := g.edges.get(from) or { []End[V, E]{} }
	ends << End[V, E]{to, label}
	g.edges.set(from, ends)
}

pub fn (g &Graph[V, E]) successors(v V) []V {
	ends := g.edges.get(v) or { return []V{} }
	mut out := []V{}
	for e in ends {
		out << e.to
	}
	return out
}

pub fn (g &Graph[V, E]) has_cycle() bool {
	_, leftover := g.kahn()
	return leftover.len > 0
}

pub fn (g &Graph[V, E]) topo_sort() ![]V {
	order, leftover := g.kahn()
	if leftover.len > 0 {
		return error('graph has a cycle involving ${leftover}')
	}
	return order
}

fn (g &Graph[V, E]) kahn() ([]V, []V) {
	mut indeg := new_hash_map[V, int]()
	for n in g.nodes.keys() {
		indeg.set(n, 0)
	}
	for from in g.edges.keys() {
		for e in g.edges.get(from) or { []End[V, E]{} } {
			indeg.set(e.to, (indeg.get(e.to) or { 0 }) + 1)
		}
	}
	mut queue := []V{}
	for n in g.nodes.keys() {
		if (indeg.get(n) or { 0 }) == 0 {
			queue << n
		}
	}
	mut order := []V{}
	mut head := 0
	for head < queue.len {
		n := queue[head]
		head++
		order << n
		for e in g.edges.get(n) or { []End[V, E]{} } {
			d := (indeg.get(e.to) or { 0 }) - 1
			indeg.set(e.to, d)
			if d == 0 {
				queue << e.to
			}
		}
	}
	mut leftover := []V{}
	for n in g.nodes.keys() {
		if (indeg.get(n) or { 0 }) > 0 {
			leftover << n
		}
	}
	return order, leftover
}

pub fn (g &Graph[V, E]) str() string {
	mut out := []string{}
	for n in g.nodes.keys() {
		for e in g.edges.get(n) or { []End[V, E]{} } {
			out << '${n} -> ${e.to} (${e.label})'
		}
	}
	return out.join('\n')
}
