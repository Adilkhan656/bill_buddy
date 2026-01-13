import java.util.Properties
import java.io.FileInputStream
plugins {
    id("com.android.application")
   
    id("org.jetbrains.kotlin.android") 
   
    id("dev.flutter.flutter-gradle-plugin")
    
    id("com.google.gms.google-services") 
}
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
android {
    namespace = "com.example.bill_buddy" // Your Package Name
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
      isCoreLibraryDesugaringEnabled = true
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
 signingConfigs {
        create("release") {
            // Load the key.properties file
            val keystorePropertiesFile = rootProject.file("key.properties")
            val keystoreProperties = Properties()
            
            if (keystorePropertiesFile.exists()) {
                keystoreProperties.load(FileInputStream(keystorePropertiesFile))
            }

            // Assign values safely using getProperty()
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storePassword = keystoreProperties.getProperty("storePassword")
            
            // Fix the storeFile logic
            val storeFileName = keystoreProperties.getProperty("storeFile")
            if (storeFileName != null) {
                storeFile = file(storeFileName)
            }
        }
    }
    buildTypes {
        release {
            // signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    // Import the Firebase BoM (Bill of Materials)
    // I corrected your version "34.7.0" (which doesn't exist) to a valid recent one "33.7.0"
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    
    // Add the dependencies for the Firebase products you want to use
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth") 
}
///adilrazakhan158@gmail.com