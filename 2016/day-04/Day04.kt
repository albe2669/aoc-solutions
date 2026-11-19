import common.Reader

class Day04 : common.Day {
    override val name = "Day 4"

    fun parseLine(line: String): Triple<String, Int, String>? {
      val (name, sectorId, checksum) = Regex("""([a-z-]+)-(\d+)\[([a-z]+)]""").find(line)?.destructured ?: return null
      return Triple(name, sectorId.toInt(), checksum)
    }

    override fun part1(reader: Reader): String {
      return reader.allLines().map { line ->
        val (name, sectorId, checksum) = parseLine(line) ?: return@map 0
        val counts = name
          .filter { it != '-' }
          .groupingBy { it }
          .eachCount()
          .entries
          .sortedWith(compareByDescending<Map.Entry<Char, Int>> { it.value }
            .thenBy { it.key })
        val calculatedChecksum = counts.take(5).map { it.key }.joinToString("")
        if (calculatedChecksum == checksum) sectorId else 0
      }.sum().toString()
    }

    override fun part2(reader: Reader): String {
      return reader.allLines().mapNotNull { line ->
        val (name, sectorId, checksum) = parseLine(line) ?: return@mapNotNull null
        val actualName = name.split("-").joinToString(" ") { word ->
          word.map { char ->
            val shifted = (char - 'a' + sectorId) % 26
            ('a' + shifted)
          }.joinToString("")
        }

        if (actualName == "northpole object storage") sectorId.toString() else null
      }.first()
    }
}
