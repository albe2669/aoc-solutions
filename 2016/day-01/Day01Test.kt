import common.Reader
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class Day01Test {
  private val day = Day01()

  @Test
  fun `part1 ends 5 blocks away after R2 L3`() {
    assertEquals("5", day.part1(Reader.of("R2, L3")))
  }

  @Test
  fun `part1 ends 2 blocks away after R2 R2 R2`() {
    assertEquals("2", day.part1(Reader.of("R2, R2, R2")))
  }

  @Test
  fun `part1 ends 12 blocks away after R5 L5 R5 R3`() {
    assertEquals("12", day.part1(Reader.of("R5, L5, R5, R3")))
  }

  @Test
  fun `part2 finds the first position visited twice`() {
    assertEquals("4", day.part2(Reader.of("R8, R4, R4, R8")))
  }
}
