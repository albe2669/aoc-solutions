import common.Reader
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class Day07Test {
  private val day = Day07()

  @Test
  fun `part1 example`() {
    assertEquals("example input", day.part1(Reader.of("example input")))
  }

  @Test
  fun `part2 example`() {
    assertEquals("example input", day.part2(Reader.of("example input")))
  }
}
