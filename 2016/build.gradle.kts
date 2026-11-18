plugins {
    kotlin("jvm") version "2.4.21"
    application
}

repositories { mavenCentral() }

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter:5.13.4")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

val dayDirs = rootDir.listFiles()?.filter { it.isDirectory && it.name.startsWith("day-") } ?: emptyList()

sourceSets {
    main {
        kotlin.srcDir("common/src")
        kotlin.srcDir("src")
        dayDirs.forEach { kotlin.srcDir(it) }
        kotlin.exclude("**/*Test.kt")
    }
    test {
        kotlin.srcDir("common/src")
        kotlin.srcDir("src")
        dayDirs.forEach { kotlin.srcDir(it) }
    }
}

application { mainClass = "MainKt" }

tasks.test { useJUnitPlatform() }
