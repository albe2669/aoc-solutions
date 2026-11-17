package common

object TestCheck {
    private var failures = 0

    fun check(description: String, actual: Any?, expected: Any?) {
        if (actual != expected) {
            failures++
            println("FAIL: $description — expected: $expected, actual: $actual")
        }
    }

    fun resetTestState() {
        failures = 0
    }

    fun reportResults(suiteName: String): Boolean {
        if (failures == 0) {
            println("PASS: $suiteName")
            return true
        }
        println("$failures check(s) failed in $suiteName")
        return false
    }
}
