import common.runDay
import kotlin.system.exitProcess

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        System.err.println("Usage: aoc2016 <day> [p1|p2] [--test]")
        exitProcess(1)
    }

    val dayNumber = args[0].toIntOrNull()?.toString()?.padStart(2, '0')
        ?: run {
            System.err.println("Invalid day: ${args[0]}")
            exitProcess(1)
        }

    val day = when (dayNumber) {
        "01" -> Day01()
        "02" -> Day02()
        "03" -> Day03()
        else -> {
            System.err.println("Day $dayNumber not implemented yet")
            exitProcess(1)
        }
    }

    val part = if (args.contains("p2")) 2 else 1
    val testInput = args.contains("--test")
    runDay(day, part, testInput)
}
