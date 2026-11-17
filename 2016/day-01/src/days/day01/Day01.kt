package days.day01

import common.Reader
import kotlin.math.abs

class Day01 : common.Day {
    override val name = "Day 1"

    private fun Pair<Int, Int>.rot(turn: Char) =
        if (turn == 'L') -second to first else second to -first

    private fun path(reader: Reader): Sequence<Pair<Int, Int>> = sequence {
        var x = 0
        var y = 0
        var dir = 0 to 1
        yield(x to y)
        for (step in reader.allString().trim().split(", ")) {
            dir = dir.rot(step.first())
            repeat(step.drop(1).toInt()) {
                x += dir.first
                y += dir.second
                yield(x to y)
            }
        }
    }

    override fun part1(reader: Reader): String =
        path(reader).last().let { (x, y) -> (abs(x) + abs(y)).toString() }

    override fun part2(reader: Reader): String {
        val visited = mutableSetOf<Pair<Int, Int>>()
        val (x, y) = path(reader).first { !visited.add(it) }
        return (abs(x) + abs(y)).toString()
    }
}
