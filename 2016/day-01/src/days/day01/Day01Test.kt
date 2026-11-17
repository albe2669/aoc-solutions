package days.day01

import common.Reader
import common.TestCheck.check
import common.TestCheck.reportResults
import common.TestCheck.resetTestState

fun main() {
    val day = Day01()
    var allPass = true

    resetTestState()
    check("part1 R2 L3", day.part1(Reader.of("R2, L3")), "5")
    check("part1 R2 R2 R2", day.part1(Reader.of("R2, R2, R2")), "2")
    check("part1 R5 L5 R5 R3", day.part1(Reader.of("R5, L5, R5, R3")), "12")
    allPass = reportResults("day-01 part1") && allPass

    resetTestState()
    check("part2 R8 R4 R4 R8", day.part2(Reader.of("R8, R4, R4, R8")), "4")
    allPass = reportResults("day-01 part2") && allPass

    if (!allPass) kotlin.system.exitProcess(1)
}
