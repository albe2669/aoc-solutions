module common

pub fn permutations[T](arr []T) [][]T {
	if arr.len == 0 {
		return [[]T{}]
	}

	mut result := [][]T{}
	for i, v in arr {
		mut sub_arr := arr.clone()
		sub_arr.delete(i)
		for perm in permutations(sub_arr) {
			result << [v]
			for p in perm {
				result[result.len - 1] << p
			}
		}
	}

	return result
}

