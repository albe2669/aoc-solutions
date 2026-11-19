import common.Reader
import java.security.MessageDigest

class Day05 : common.Day {
  override val name = "Day 5"

  fun String.md5(): String {
    val md = MessageDigest.getInstance("MD5")
    val digest = md.digest(this.toByteArray())
    return digest.toHexString()
  }

  fun generator(doorCode: String): Sequence<String> =
    sequence {
      var index = 0
      while (true) {
        val hash = "$doorCode$index".md5()
        if (hash.startsWith("00000")) {
          yield(hash)
        }
        index++
      }
    }

  override fun part1(reader: Reader): String {
    val doorCode = reader.nextLine()?.trim() ?: throw IllegalArgumentException("Input cannot be null")
    return generator(doorCode).take(8).map { it[5] }.joinToString("")
  }

  override fun part2(reader: Reader): String {
    val doorCode = reader.nextLine()?.trim() ?: throw IllegalArgumentException("Input cannot be null")

    return generator(doorCode)
      .map { it.substring(5, 7) }
      .filter { it[0] in '0'..'7' }
      .distinctBy { it[0] }
      .take(8)
      .sortedBy { it[0] }
      .map { it[1] }
      .joinToString("")
  }
}
