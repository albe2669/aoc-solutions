module common

struct NodeKey {
	label rune
}

fn (k NodeKey) hash() int {
	return int(k.label)
}

fn key(label rune) NodeKey {
	return NodeKey{label}
}

fn chain() Graph[NodeKey, int] {
	mut g := new_graph[NodeKey, int]()
	g.add_edge(key(`a`), key(`b`), 1)
	g.add_edge(key(`b`), key(`c`), 2)
	return g
}

fn test_add_node() {
	mut g := new_graph[NodeKey, string]()
	g.add_node(key(`a`))
	g.add_node(key(`a`))
	assert g.successors(key(`a`)) == []NodeKey{}
}

fn test_add_edge_creates_endpoints() {
	g := chain()
	assert g.successors(key(`a`)) == [key(`b`)]
	assert g.successors(key(`c`)) == []NodeKey{}
}

fn test_successors_missing_node() {
	g := new_graph[NodeKey, int]()
	assert g.successors(key(`z`)) == []NodeKey{}
}

fn test_topo_sort_chain() {
	g := chain()
	order := g.topo_sort() or { assert false; return }
	assert order == [key(`a`), key(`b`), key(`c`)]
}

fn test_topo_sort_diamond() {
	mut g := new_graph[NodeKey, int]()
	g.add_edge(key(`a`), key(`b`), 1)
	g.add_edge(key(`a`), key(`c`), 1)
	g.add_edge(key(`b`), key(`d`), 1)
	g.add_edge(key(`c`), key(`d`), 1)
	order := g.topo_sort() or { assert false; return }
	assert order[0] == key(`a`)
	assert order[3] == key(`d`)
	assert order.len == 4
}

fn test_topo_sort_empty() {
	g := new_graph[NodeKey, int]()
	order := g.topo_sort() or { assert false; return }
	assert order.len == 0
}

fn test_has_cycle_false() {
	assert chain().has_cycle() == false
}

fn test_has_cycle_true() {
	mut g := new_graph[NodeKey, int]()
	g.add_edge(key(`a`), key(`b`), 1)
	g.add_edge(key(`b`), key(`a`), 1)
	assert g.has_cycle()
}

fn test_has_cycle_self_loop() {
	mut g := new_graph[NodeKey, int]()
	g.add_edge(key(`x`), key(`x`), 1)
	assert g.has_cycle()
}

fn test_topo_sort_cycle_is_error() {
	mut g := new_graph[NodeKey, int]()
	g.add_edge(key(`a`), key(`b`), 1)
	g.add_edge(key(`b`), key(`c`), 1)
	g.add_edge(key(`c`), key(`a`), 1)
	g.add_node(key(`d`))
	g.topo_sort() or { assert g.has_cycle(); return }
	assert false
}

fn test_isolated_nodes_ordered() {
	mut g := new_graph[NodeKey, int]()
	g.add_node(key(`a`))
	g.add_node(key(`b`))
	order := g.topo_sort() or { assert false; return }
	assert order.len == 2
	assert g.has_cycle() == false
}
