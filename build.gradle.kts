plugins {
    id("java")
    id("org.jetbrains.kotlin.jvm") version "1.9.0"
    id("org.jetbrains.intellij") version "1.15.0"
    id("org.openjfx.javafxplugin") version "0.0.14"
    antlr
}

group = "com.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    antlr("org.antlr:antlr4:4.5")
    implementation("org.antlr:antlr4-intellij-adaptor:0.1")
}

// Configure Gradle IntelliJ Plugin
// Read more: https://plugins.jetbrains.com/docs/intellij/tools-gradle-intellij-plugin.html
intellij {
    version.set("2023.2")
    type.set("IU") // Target IDE Platform

    plugins.set(listOf(/* Plugin Dependencies */))
}

javafx {
    modules("javafx.controls", "javafx.graphics", "javafx.swing", "javafx.base")
}

tasks {
    // Set the JVM compatibility versions
    withType<JavaCompile> {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }
     withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
         kotlinOptions.jvmTarget = "17"
     }

    patchPluginXml {
        sinceBuild.set("232")
        untilBuild.set("232.*")
    }

    signPlugin {
        certificateChain.set(System.getenv("CERTIFICATE_CHAIN"))
        privateKey.set(System.getenv("PRIVATE_KEY"))
        password.set(System.getenv("PRIVATE_KEY_PASSWORD"))
    }

    publishPlugin {
        token.set(System.getenv("PUBLISH_TOKEN"))
    }

    generateGrammarSource {
        arguments = arguments + listOf("-package", "com.example.intellijuvlplugin.language.parser")
    }
}