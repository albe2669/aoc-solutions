# Advent of Code 2016 — Kotlin

One directory per day, shared `common` module. Gradle build with JUnit 5, all Gradle files live in `2016/`; `just` recipes wrap `./gradlew`.

## Layout

```
2016/
  day-01/Day01.kt, Day01Test.kt, input.in, test.in
  common/src/common/   Reader, Day
  src/Main.kt          entry point
  template/             scaffold for `just new`
  gradlew, gradle/, build.gradle.kts, settings.gradle.kts
```

## Commands

Run `just --list` for all recipes. The core ones:

- `just build` — compile everything (incremental)
- `just test` — run all JUnit test suites
- `just test <day>` — run one day's tests, e.g. `just test 1`
- `just run <day> [p1|p2] [--test]` — run a solution (`--test` uses `test.in`)
- `just new <day>` — scaffold a new day from `template/`

Recipes call `./gradlew --offline --quiet`. Remove `--offline` only if a new dependency was added.

## Adding a new day

1. `just new 7` — creates `day-07/` with `Day07.kt`, `Day07Test.kt`, `input.in`, `test.in`
2. Write the solution in `day-07/Day07.kt` (default package, implements `common.Day`)
3. Add example cases to `day-07/Day07Test.kt` as JUnit `@Test` methods with `assertEquals`
4. Register the day in `src/Main.kt` in the `when` block
5. Put your puzzle input in `day-07/input.in`; put the example input in `test.in`

Gradle finds day source directories automatically; no build file change is needed for a new day.

`common` provides:

- `common.Reader` — byte/line/int reading over the input
- `common.Day` — the interface each day implements

Each day's test class uses JUnit 5. `just test` runs every `*Test.kt` and reports pass/fail.
