# Advent of Code 2016 — Kotlin

One module per day, shared `common` module, no build system: `kotlinc` via `just`.

## Commands

Run `just --list` inside `2016/` for all recipes. The core ones:

- `just build` — compile everything to `build/`
- `just test` — run all day test suites
- `just run <day> [p1|p2] [--test]` — run a solution (`--test` uses `test.in`)
- `just new <day>` — scaffold a new day from `template/`

## Adding a new day

1. `just new 7` — creates `day-07/` with `Day07.kt`, `Day07_test.kt`, `input.in`, `test.in`
2. Write the solution in `day-07/src/days/day07/Day07.kt`
3. Add example cases to `day-07/src/days/day07/Day07_test.kt` as `check(...)` calls
4. Register the day in `src/main/Main.kt` in the `when` block
5. Put your puzzle input in `day-07/input.in`; put the example input in `test.in`

`common` provides:

- `common.Reader` — byte/line/int reading over the input, mirrors the 2015 V setup
- `common.Day` — the interface each day implements
- `common.TestCheck` — `check(desc, actual, expected)`, `reportResults(suite)`, `resetTestState()`

Each day's test file is a `main()` that runs its checks and exits non-zero on failure. `just test` compiles and runs every `*_test.kt` and reports pass/fail.
