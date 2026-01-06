# Android Build Troubleshooting Guide

## ✅ Issue Fixed: Core Library Desugaring

### Problem:
```
Dependency ':flutter_local_notifications' requires core library desugaring
```

### Solution Applied:
Updated `android/app/build.gradle.kts` with:

1. **Enabled desugaring in compileOptions:**
```kotlin
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
    isCoreLibraryDesugaringEnabled = true  // ✅ Added this
}
```

2. **Added desugaring dependency:**
```kotlin
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```

### What is Core Library Desugaring?
Core library desugaring allows you to use Java 8+ APIs (like `java.time`) on older Android versions (API level < 26). The `flutter_local_notifications` package requires this for timezone support.

---

## 🔧 Common Android Build Issues & Fixes

### Issue 1: Gradle Build Failed
**Error:** `Gradle task assembleDebug failed`

**Solutions:**
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter run
```

---

### Issue 2: SDK Version Mismatch
**Error:** `compileSdkVersion` or `minSdkVersion` issues

**Fix:** Update `android/app/build.gradle.kts`:
```kotlin
android {
    compileSdk = 34  // Latest stable
    
    defaultConfig {
        minSdk = 21   // Minimum Android 5.0
        targetSdk = 34
    }
}
```

---

### Issue 3: Java Version Issues
**Error:** `Java version` or `JDK` errors

**Fix:** Ensure Java 17 is configured:
```kotlin
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

kotlinOptions {
    jvmTarget = "17"
}
```

---

### Issue 4: Multidex Required
**Error:** `Cannot fit requested classes in a single dex file`

**Fix:** Add to `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    multiDexEnabled = true
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}
```

---

### Issue 5: Permission Issues
**Error:** Permission denied errors

**Fix:** Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

---

### Issue 6: Namespace Issues
**Error:** `Namespace not specified`

**Fix:** Ensure namespace is set in `build.gradle.kts`:
```kotlin
android {
    namespace = "com.example.bettermuslim"
}
```

---

## 🚀 Quick Commands

### Clean and Rebuild:
```bash
flutter clean
flutter pub get
flutter run
```

### Build APK:
```bash
flutter build apk --release
```

### Build App Bundle:
```bash
flutter build appbundle --release
```

### Check for Issues:
```bash
flutter doctor
flutter doctor -v
```

---

## 📱 Device Setup

### Android Emulator:
1. Open Android Studio
2. Tools → Device Manager
3. Create Virtual Device
4. Select device (e.g., Pixel 6)
5. Download system image (API 34)
6. Start emulator

### Physical Device:
1. Enable Developer Options:
   - Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Settings → Developer Options
   - Enable "USB Debugging"
3. Connect via USB
4. Run: `flutter devices`

---

## 🔍 Debugging Tips

### View Gradle Logs:
```bash
flutter run --verbose
```

### Check Device Connection:
```bash
flutter devices
adb devices
```

### Clear Gradle Cache:
```bash
cd android
./gradlew clean
cd ..
flutter clean
```

### Rebuild Gradle:
```bash
cd android
./gradlew --stop
cd ..
flutter run
```

---

## ⚙️ Gradle Configuration Reference

### Complete `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.bettermuslim"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.bettermuslim"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("androidx.multidex:multidex:2.0.1")
}
```

---

## 📝 AndroidManifest.xml Permissions

### Location: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />
    
    <application
        android:label="BetterMuslim"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- Activity configuration -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

---

## ✅ Verification Checklist

After fixing build issues:

- [ ] Run `flutter doctor` - All checks pass
- [ ] Run `flutter clean` - Clears old builds
- [ ] Run `flutter pub get` - Updates dependencies
- [ ] Run `flutter run` - App builds successfully
- [ ] Check emulator/device - App launches
- [ ] Test features - All working

---

## 🆘 Still Having Issues?

### 1. Update Flutter:
```bash
flutter upgrade
flutter doctor
```

### 2. Update Android SDK:
- Open Android Studio
- SDK Manager → Update all

### 3. Check Java Version:
```bash
java -version  # Should be 17+
```

### 4. Reinstall Dependencies:
```bash
flutter clean
rm -rf pubspec.lock
flutter pub get
```

### 5. Check Flutter Doctor:
```bash
flutter doctor -v
```

---

## 📚 Resources

- [Flutter Android Setup](https://flutter.dev/docs/get-started/install/windows#android-setup)
- [Android Gradle Plugin](https://developer.android.com/studio/releases/gradle-plugin)
- [Core Library Desugaring](https://developer.android.com/studio/write/java8-support#library-desugaring)
- [Flutter Troubleshooting](https://flutter.dev/docs/testing/debugging)

---

**Your build should now work! 🎉**

If you encounter any other issues, refer to this guide or run `flutter doctor -v` for detailed diagnostics.
