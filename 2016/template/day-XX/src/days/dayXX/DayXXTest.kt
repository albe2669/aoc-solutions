package days.dayXX

import common.Reader
import common.TestCheck.check
import common.TestCheck.reportResults
import common.TestCheck.resetTestState

fun main() {
    val day = DayXX()
    var allPass = true

    resetTestState()
    check("part1 example", day.part1(Reader.of("example input")), "example input")
    allPass = reportResults("day-XX part1") && allPass

    resetTestState()
    check("part2 example", day.part2(Reader.of("example input")), "example input")
    allPass = reportResults("day-XX part2") && allPass

    if (!allPass) kotlin.system.exitProcess(1)
}
