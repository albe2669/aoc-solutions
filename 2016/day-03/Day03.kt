import common.Reader

class Day03 : common.Day {
    override val name = "Day 3"

    override fun part1(reader: Reader): String {
      return reader.allLines().map { line ->
          line.trim().split(Regex("\\s+")).map { it.toInt() }.sorted()
      }.count { (a, b, c) -> a + b > c }.toString()
    }

    override fun part2(reader: Reader): String {
      return reader.allLines().map { line ->
          line.trim().split(Regex("\\s+")).map { it.toInt() }
      }.chunked(3).flatMap { (a, b, c) -> // a, b, c are 3 rows of 3 numbers each
          listOf(
              listOf(a[0], b[0], c[0]).sorted(),
              listOf(a[1], b[1], c[1]).sorted(),
              listOf(a[2], b[2], c[2]).sorted()
          )
      }.count { (x, y, z) -> x + y > z }.toString()
    }
}
