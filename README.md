# MonoLibro Mobile

\[!\]== CURRENTLY DEVELOPING ==\[!\]

The mobile client for the MonoLibro Protocol.

## Clone, Build and Debug

Software requirement:
 - Git
 - Flutter
 - Dart
 - Android SDK
 - ADB / Andoroid Emulator (Can be created / connected via Android SDK Platform-Tools)

To clone the repository:
```sh
git clone https://github.com/MonoLibro/monolibro-mobile.git
```

To Build for "Release" (Will result in the Build directory)
```sh
# At project root
flutter clean
flutter pub get
flutter build apk
```

To Build and Debug with Hot Reload
```sh
# At project root

# (Connect your device via ADB or use the following commend to start your emulator)
flutter emulator --launch [Emulator ID] # Repelace the [Emulator ID] to your Emulator ID

# Build and Run on connected devices.
flutter run
```
