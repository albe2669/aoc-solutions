import common.Reader

class Day02 : common.Day {
  override val name = "Day 2"

  val keypad1 =
    listOf(
      listOf('1', '2', '3'),
      listOf('4', '5', '6'),
      listOf('7', '8', '9'),
    )

  val keypad2 =
    listOf(
      listOf(null, null, '1', null, null),
      listOf(null, '2', '3', '4', null),
      listOf('5', '6', '7', '8', '9'),
      listOf(null, 'A', 'B', 'C', null),
      listOf(null, null, 'D', null, null),
    )

  val directions =
    mapOf(
      'U' to (0 to -1),
      'D' to (0 to 1),
      'L' to (-1 to 0),
      'R' to (1 to 0),
    )

  fun walk(
    reader: Reader,
    keypad: List<List<Char?>>,
    startX: Int,
    startY: Int,
  ): String {
    val code = StringBuilder()

    var x = startX
    var y = startY
    for (line in reader.allLines()) {
      for (c in line) {
        val (dx, dy) = directions[c] ?: continue
        val newX = (x + dx).coerceIn(0, keypad[0].size - 1)
        val newY = (y + dy).coerceIn(0, keypad.size - 1)

        if (keypad[newY][newX] != null) {
          x = newX
          y = newY
        }
      }

      code.append(keypad[y][x])
    }

    return code.toString()
  }

  override fun part1(reader: Reader): String = walk(reader, keypad1, 1, 1)

  override fun part2(reader: Reader): String = walk(reader, keypad2, 0, 2)
}
