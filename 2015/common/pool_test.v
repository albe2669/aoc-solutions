module common

import time

struct CountIter {
mut:
	count int
}

fn (mut it CountIter) next() ?int {
	if it.count >= 30 {
		return none
	}
	it.count++
	return it.count
}

fn test_pool_returns_first_match() {
	mut pool := new_pool(4, fn (n int) ?int {
		if n == 17 {
			return n
		}
		return none
	})
	mut iter := CountIter{}
	res := pool.work(mut iter) or { panic('no result') }
	assert res == 17
}

fn test_pool_returns_none_when_no_match() {
	mut pool := new_pool(2, fn (n int) ?int {
		return none
	})
	mut iter := CountIter{}
	pool.work(mut iter) or { return }
	panic('work must return none when no job yields a result')
}

fn test_pool_cancels_pending_work() {
	mut pool := new_pool(2, fn (n int) ?int {
		if n == 1 {
			return n
		}
		return none
	})
	mut iter := CancellingIter{}
	res := pool.work(mut iter) or { panic('no result') }
	assert res == 1
	// the iterator holds 1000 jobs, but the match on the first job cancels
	// the rest before the pool can consume them
	assert iter.consumed < 1000
}

struct CancellingIter {
mut:
	pos      int
	consumed int
}

fn (mut it CancellingIter) next() ?int {
	if it.pos >= 1000 {
		return none
	}
	it.pos++
	it.consumed = it.pos
	return it.pos
}

fn test_pool_waits_for_in_flight_jobs() {
	mut pool := new_pool(4, fn (n int) ?int {
		time.sleep(50 * time.millisecond)
		return n
	})
	mut iter := CountIter{}
	res := pool.work(mut iter) or { panic('no result') }
	assert res >= 1
}

fn test_pool_two_pools_sequential() {
	mut iter1 := CountIter{}
	mut pool1 := new_pool(2, fn (n int) ?int {
		if n == 5 {
			return n
		}
		return none
	})
	mut iter2 := CountIter{}
	mut pool2 := new_pool(2, fn (n int) ?int {
		if n == 9 {
			return n
		}
		return none
	})
	r1 := pool1.work(mut iter1) or { panic('no result') }
	r2 := pool2.work(mut iter2) or { panic('no result') }
	assert r1 == 5
	assert r2 == 9
}
