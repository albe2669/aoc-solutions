module common

struct TestKey {
	label rune
}

fn (k TestKey) hash() int {
	return int(k.label)
}

fn test_set_get() {
	mut h := new_hash_map[TestKey, string]()
	h.set(TestKey{`x`}, 'one')
	assert h.get(TestKey{`x`}) or { 'missing' } == 'one'
}

fn test_get_missing_key() {
	mut h := new_hash_map[TestKey, string]()
	h.set(TestKey{`x`}, 'one')
	h.get(TestKey{`y`}) or { return }
	assert false
}

fn test_set_overwrites() {
	mut h := new_hash_map[TestKey, int]()
	h.set(TestKey{`k`}, 1)
	h.set(TestKey{`k`}, 2)
	assert h.get(TestKey{`k`}) or { -1 } == 2
	assert h.len() == 1
}

fn test_distinct_keys() {
	mut h := new_hash_map[TestKey, int]()
	h.set(TestKey{`a`}, 1)
	h.set(TestKey{`b`}, 2)
	assert h.len() == 2
	assert h.get(TestKey{`a`}) or { -1 } == 1
	assert h.get(TestKey{`b`}) or { -1 } == 2
}

fn test_empty_len() {
	h := new_hash_map[TestKey, string]()
	assert h.len() == 0
}

fn test_equal_hash_same_slot() {
	mut h := new_hash_map[string, string]()
	h.set('aa', 'first')
	h.set('bb', 'second')
	assert h.get('aa') or { 'missing' } == 'first'
	assert h.get('bb') or { 'missing' } == 'second'
	assert h.len() == 2
}
