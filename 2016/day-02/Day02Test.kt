import common.Reader
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class Day02Test {
    private val day = Day02()

    @Test
    fun `part1 example`() {
        assertEquals("1985", day.part1(Reader.of("ULL\nRRDDD\nLURDL\nUUUUD")))
    }

    @Test
    fun `part2 example`() {
        assertEquals("example input", day.part2(Reader.of("example input")))
    }
}
