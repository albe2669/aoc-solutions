import common.Reader

class Day07 : common.Day {
  override val name = "Day 7"

  fun String.containsAbba(): Boolean {
    this.forEachIndexed { i, _ ->
      if (i + 3 < this.length) {
        if (this[i] == this[i + 3] && this[i + 1] == this[i + 2] && this[i] != this[i + 1]) {
          return true
        }
      }
    }
    return false
  }

  override fun part1(reader: Reader): String =
    reader
      .allLines()
      .map { line ->
        val parts = line.split("[", "]")
        val supernetSequences = parts.filterIndexed { index, _ -> index % 2 == 0 }
        val hypernetSequences = parts.filterIndexed { index, _ -> index % 2 == 1 }

        if (supernetSequences.any { it.containsAbba() } && !hypernetSequences.any { it.containsAbba() }) {
          1
        } else {
          0
        }
      }.sum()
      .toString()

  override fun part2(reader: Reader): String =
    reader
      .allLines()
      .map { line ->
        val parts = line.split("[", "]")
        val supernetSequences = parts.filterIndexed { index, _ -> index % 2 == 0 }
        val hypernetSequences = parts.filterIndexed { index, _ -> index % 2 == 1 }

        val babList =
          supernetSequences.fold(mutableSetOf<String>()) { acc, seq ->
            seq.forEachIndexed { i, _ ->
              if (i + 2 < seq.length) {
                if (seq[i] == seq[i + 2] && seq[i] != seq[i + 1]) {
                  acc.add("${seq[i + 1]}${seq[i]}${seq[i + 1]}")
                }
              }
            }
            acc
          }

        if (hypernetSequences.any { seq ->
            babList.any { bab -> seq.contains(bab) }
          }
        ) {
          1
        } else {
          0
        }
      }.sum()
      .toString()
}
