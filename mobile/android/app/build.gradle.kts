plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.indianlaw.indian_constitution_vault"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion removed to use default NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.indianlaw.indian_constitution_vault"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            abiFilters.clear()
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a"))
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = "upload"
            keyPassword = "App_P@sswOrd!K3y_20*25"
            storeFile = file("../../../upload-keystore.jks")
            storePassword = "App_P@sswOrd!K3y_20*25"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // Signing with the release keys
        }
    }
}

flutter {
    source = "../.."
}
