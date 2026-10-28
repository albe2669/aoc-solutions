module common

pub struct Reader {
mut:
	data []u8
	pos  int
}

// These functions return errors instead of panicking, so that the caller can decide how to handle malformed input. In the context of Advent of Code, an error usually means a bug in the parsing logic, because the input is well-formed.

pub fn create_test_reader(input string) Reader {
	return Reader{
		data: input.bytes()
	}
}

fn (mut r Reader) read_one() ?u8 {
	if r.pos >= r.data.len {
		return none
	}
	byte := r.data[r.pos]
	r.pos++
	return byte
}

pub fn (mut r Reader) next_byte() !u8 {
	byte := r.read_one() or { return error('no more bytes left in input stream') }
	return byte
}

pub fn (mut r Reader) next_rune() !rune {
	first := r.next_byte()!
	if first < 0x80 {
		return rune(first)
	}
	// continuation pattern: 10xxxxxx
	if first & 0xC0 == 0x80 {
		return error('invalid utf8: continuation byte 0x${first:02X} at start of rune')
	}
	length := if first & 0xE0 == 0xC0 {
		2
	} else if first & 0xF0 == 0xE0 {
		3
	} else if first & 0xF8 == 0xF0 {
		4
	} else {
		return error('invalid utf8: unexpected leading byte 0x${first:02X}')
	}
	mut value := rune(first & (0x7F >> (length - 1)))
	for i := 1; i < length; i++ {
		cont := r.next_byte()!
		if cont & 0xC0 != 0x80 {
			return error('invalid utf8: expected continuation byte, got 0x${cont:02X}')
		}
		value = value << 6 | rune(cont & 0x3F)
	}
	return value
}

pub fn (mut r Reader) next_line() !string {
	mut line := []u8{}
	for {
		byte := r.read_one() or {
			if line.len == 0 {
				return error('no more lines left in input stream')
			}
			return line.bytestr()
		}
		if byte == `\n` {
			if line.len > 0 && line[line.len - 1] == `\r` {
				line.delete_last()
			}
			return line.bytestr()
		}
		line << byte
	}
	panic('unreachable') // ponytail: for-loop exhaustiveness; compiler cannot prove termination
}

pub fn (mut r Reader) next_n_bytes(n int) ![]u8 {
	if r.data.len - r.pos < n {
		return error('not enough bytes left in input stream')
	}
	bytes := r.data[r.pos..r.pos + n]
	r.pos += n
	return bytes
}

pub fn (mut r Reader) next_n_string(n int) !string {
	return r.next_n_bytes(n)!.bytestr()
}

pub fn (mut r Reader) all_bytes() ![]u8 {
	bytes := r.data[r.pos..]
	r.pos = r.data.len
	return bytes
}

pub fn (mut r Reader) all_string() !string {
	return r.all_bytes()!.bytestr()
}

pub fn (mut r Reader) next_int() !int {
	mut digits := []u8{}
	for {
		byte := r.read_one() or { break }
		is_digit := byte >= `0` && byte <= `9`
		is_sign := digits.len == 0 && (byte == `-` || byte == `+`)
		if is_digit || is_sign {
			digits << byte
		} else {
			r.pos-- // push the non-digit back so the caller can read it
			break
		}
	}
	if digits.len == 0 {
		return error('no integer found in input stream')
	}
	if digits.len == 1 && (digits[0] == `-` || digits[0] == `+`) {
		r.pos-- // push the sign back so the caller can re-read the stream
		return error('no integer found in input stream')
	}
	return digits.bytestr().int()
}
