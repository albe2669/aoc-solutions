package common

class Reader(
  private val data: ByteArray,
) {
  private var pos = 0

  companion object {
    fun of(input: String) = Reader(input.toByteArray())

    fun ofFile(path: String) =
      Reader(
        java.nio.file.Files
          .readAllBytes(
            java.nio.file.Path
              .of(path),
          ),
      )
  }

  fun hasMore(): Boolean = pos < data.size

  fun nextByte(): Byte? {
    if (!hasMore()) return null
    return data[pos++]
  }

  fun nextLine(): String? {
    if (!hasMore()) return null
    val sb = StringBuilder()
    while (hasMore()) {
      val b = data[pos++]
      if (b == '\n'.code.toByte()) break
      sb.append(b.toInt().toChar())
    }
    var line = sb.toString()
    if (line.endsWith('\r')) line = line.dropLast(1)
    return line
  }

  fun allLines(): List<String> = generateSequence { nextLine() }.toList()

  fun allString(): String {
    val rest = String(data, pos, data.size - pos, Charsets.UTF_8)
    pos = data.size
    return rest
  }

  fun nextInt(): Int? {
    val sb = StringBuilder()
    while (hasMore()) {
      val b = data[pos]
      val isDigit = b in '0'.code.toByte()..'9'.code.toByte()
      val isSign = sb.isEmpty() && (b == '-'.code.toByte() || b == '+'.code.toByte())
      if (isDigit || isSign) {
        sb.append(b.toInt().toChar())
        pos++
      } else {
        break
      }
    }
    if (sb.isEmpty() || (sb.length == 1 && (sb[0] == '-' || sb[0] == '+'))) return null
    return sb.toString().toInt()
  }
}
