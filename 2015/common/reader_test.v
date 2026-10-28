module common

fn test_next_byte() {
	mut r := create_test_reader('ab')
	assert r.next_byte()! == `a`
	assert r.next_byte()! == `b`
}

fn test_next_byte_exhausted() {
	mut r := create_test_reader('')
	mut errored := false
	r.next_byte() or { errored = true }
	assert errored
}

fn test_next_line() {
	mut r := create_test_reader('abc\n\ndef')
	assert r.next_line()! == 'abc'
	assert r.next_line()! == ''
	assert r.next_line()! == 'def'
}

fn test_next_line_without_trailing_newline() {
	mut r := create_test_reader('abc')
	assert r.next_line()! == 'abc'
}

fn test_next_line_strips_carriage_return() {
	mut r := create_test_reader('abc\r\nrest')
	assert r.next_line()! == 'abc'
	assert r.next_line()! == 'rest'
}

fn test_next_line_exhausted() {
	mut r := create_test_reader('abc\n')
	assert r.next_line()! == 'abc'
	mut errored := false
	r.next_line() or { errored = true }
	assert errored
}

fn test_next_n_bytes() {
	mut r := create_test_reader('abc')
	assert r.next_n_bytes(2)! == 'ab'.bytes()
	assert r.next_n_bytes(1)! == 'c'.bytes()
}

fn test_next_n_bytes_exhausted() {
	mut r := create_test_reader('ab')
	mut errored := false
	r.next_n_bytes(3) or { errored = true }
	assert errored
	// the failed read consumed nothing
	assert r.next_byte()! == `a`
}

fn test_next_n_string() {
	mut r := create_test_reader('abcdef')
	assert r.next_n_string(3)! == 'abc'
	assert r.next_n_string(3)! == 'def'
}

fn test_all_bytes() {
	mut r := create_test_reader('hi!')
	assert r.all_bytes()! == 'hi!'.bytes()
}

fn test_all_string() {
	mut r := create_test_reader('line1\nline2')
	assert r.all_string()! == 'line1\nline2'
}

fn test_next_int() {
	mut r := create_test_reader('123x')
	assert r.next_int()! == 123
	assert r.next_byte()! == `x`
}

fn test_next_int_no_digits() {
	mut r := create_test_reader('xyz')
	mut errored := false
	r.next_int() or { errored = true }
	assert errored
	// the failed read consumed nothing
	assert r.next_byte()! == `x`
}

fn test_next_int_sign_only() {
	mut r := create_test_reader('-x')
	mut errored := false
	r.next_int() or { errored = true }
	assert errored
	// the sign was pushed back, the stream starts at the sign again
	assert r.next_byte()! == `-`
}

fn test_next_int_negative() {
	mut r := create_test_reader('-42')
	assert r.next_int()! == -42
}

fn test_next_int_exhausted_after_previous_int() {
	mut r := create_test_reader('12')
	assert r.next_int()! == 12
	mut errored := false
	r.next_int() or { errored = true }
	assert errored
}

fn test_next_rune() {
	mut r := create_test_reader('abc')
	assert r.next_rune()! == `a`
	assert r.next_rune()! == `b`
	assert r.next_rune()! == `c`
}

fn test_next_rune_multibyte() {
	mut r := create_test_reader('ünïcødé™🔒.')
	mut runes := []rune{}
	for i := 0; i < 10; i++ {
		runes << r.next_rune()!
	}
	assert runes == [`ü`, `n`, `ï`, `c`, `ø`, `d`, `é`, `™`, `🔒`, `.`]
}
