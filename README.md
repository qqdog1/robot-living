# robot-living

generate l10n
flutter pub run intl_utils:generate


flutter build apk --release --shrink

adb shell getprop ro.product.cpu.abi

adb install .\build\app\outputs\flutter-apk\app-arm64-v8a-release.apk