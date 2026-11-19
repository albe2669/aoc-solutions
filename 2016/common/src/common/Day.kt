package common

interface Day {
  val name: String

  fun part1(reader: Reader): String

  fun part2(reader: Reader): String
}

fun runDay(
  day: Day,
  part: Int,
  testInput: Boolean,
) {
  val baseDir = "day-${day.name.removePrefix("Day ").padStart(2, '0')}"
  val inputPath = "$baseDir/${if (testInput) "test.in" else "input.in"}"
  val input =
    try {
      java.nio.file.Files
        .readString(
          java.nio.file.Path
            .of(inputPath),
        )
    } catch (e: java.io.IOException) {
      System.err.println("Input file not found: $inputPath")
      kotlin.system.exitProcess(1)
    }
  val reader = Reader.of(input)
  val result = if (part == 1) day.part1(reader) else day.part2(reader)
  println("Day ${day.name.removePrefix("Day ")} part $part result: $result")
}
