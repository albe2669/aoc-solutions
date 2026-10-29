module common

import strings

pub interface Hashable {
	hash() int
}

pub struct HashMap[K, V] {
mut:
	data map[int]V
	keys map[int]K
}

pub fn (h HashMap[K, V]) str() string {
	mut b := strings.new_builder(100)

	for key, value in h.data {
		k := h.keys[key]
		b.writeln('Key: (${key})${k}, Value: ${value}')
	}

	return b.str()
}

pub fn new_hash_map[K, V]() HashMap[K, V] {
	return HashMap[K, V]{
		data: map[int]V{}
	}
}

pub fn (h HashMap[K, V]) get(key K) ?V {
	hashed := key.hash()
	if hashed !in h.data {
		return none
	}
	return h.data[hashed]
}

pub fn (mut h HashMap[K, V]) set(key K, value V) {
	hash := key.hash()
	h.data[hash] = value
	h.keys[hash] = key
}

pub fn (mut h HashMap[K, V]) map_or_default(key K, func fn (V) V, default V) {
	hashed := key.hash()
	if hashed in h.data {
		h.data[hashed] = func(h.data[hashed])
	} else {
		h.data[hashed] = default
	}
}

pub fn (h HashMap[K, V]) len() int {
	return h.data.len
}

