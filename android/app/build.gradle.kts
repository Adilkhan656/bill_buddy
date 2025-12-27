// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    // Use the modern Kotlin plugin ID
    id("org.jetbrains.kotlin.android") 
    // Flutter plugin
    id("dev.flutter.flutter-gradle-plugin")
    // FIREBASE (Apply it here without version)
    id("com.google.gms.google-services") 
}

android {
    namespace = "com.example.bill_buddy" // Your Package Name
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // Ensure this matches your Firebase Console package name exactly
        applicationId = "com.example.bill_buddy"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Import the Firebase BoM (Bill of Materials)
    // I corrected your version "34.7.0" (which doesn't exist) to a valid recent one "33.7.0"
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    
    // Add the dependencies for the Firebase products you want to use
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth") 
}