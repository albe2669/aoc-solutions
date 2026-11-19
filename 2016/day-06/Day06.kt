import common.Reader

class Day06 : common.Day {
  override val name = "Day 6"

  fun <T> List<List<T>>.transpose(): List<List<T>> {
    val transposed = mutableListOf<List<T>>()
    for (i in first().indices) {
      val col: MutableList<T> = ArrayList()
      forEach { row ->
        col.add(row[i])
      }
      transposed.add(col)
    }
    return transposed
  }

  override fun part1(reader: Reader): String =
    reader
      .allLines()
      .map { it.toCharArray().toList() }
      .transpose()
      .map { column -> column.groupingBy { it }.eachCount() }
      .map {
        it.maxByOrNull { entry -> entry.value }?.key
          ?: ' '
      }.joinToString("")

  override fun part2(reader: Reader): String =
    reader
      .allLines()
      .map { it.toCharArray().toList() }
      .transpose()
      .map { column -> column.groupingBy { it }.eachCount() }
      .map {
        it.minByOrNull { entry -> entry.value }?.key
          ?: ' '
      }.joinToString("")
}
