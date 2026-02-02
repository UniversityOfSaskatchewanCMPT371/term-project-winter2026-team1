# Spike Prototype: Integration Testing with Flutter and Chrome

## Goal

The goal of this spike was to check the feasability of implementing integration testing for our Flutter desktop application. One obvious risk of this is seeing if the integration tests are going to be able to run on all team members environments without needing platform specific dependencies. This spike tested two main technologies, Flutter's integration_test package, and ChromeDriver.
A large portion of information and code was taken from here:
https://docs.flutter.dev/testing/integration-tests

## Technologies Tested

- **Flutter integration_test package**: Flutter package for end-to-end testing
- **ChromeDriver**: Driver implementation for Chrome
- **Flutter drive command**: Flutters test driver for running integration tests on different platforms

## What Was Tested

All of the testing for this spike was done locally on my machine, I created a built in flutter counter app and tested the counter button, since it was done locally i will provide a screen recording example.

Testing goes as follows:
1. Launch flutter app in chrome
2. Verify initial UI state (counter should be at 0)
3. Simulate user interaction (click the button to increment counter)
4. Assert expected behavior (counter increments to 1)

### Testing Approach

Three different approaches were tested for running these integration tests:

1. **Mac desktop target** Required full Xcode installation and CocoaPods, too many platform specific dependencies
2. **IOS Simulator**: Also required Xcode, wasn't very appropriate for our desktop first application, may be used if we make it to cross platform developement for this project
3. **Chrome with flutter drive**: Successfully ran tests with only Chrome and ChromeDriver - no platform-specific tooling required

## What Was Learned

### platform specific barriers

Attempts to use flutter test on mac had problems:
- Required full Xcode installation 
- Required CocoaPods for mac flutter apps
- Command line tools alone were insufficient
- A completely different setup is required on Windows/Linux
- This approach would have created too much inconsistency across environments 

### ChromeDriver Version Matching 

ChromeDriver and Chrome browser versions must match exactly. 
**Solution**: Install ChromeDriver matching the Chrome version using:
'$' npx @puppeteer/browsers install chromedriver@144 --path ~/.cache/puppeteer

### flutter drive vs flutter test

flutter has two commands for integration testing:
- `flutter test`: simpler but limited platform support 
- `flutter drive`: more complex but supports web targets like Chrome which is very convenient for us

## Findings

- **Chrome based integration testing is most viable optioin**: all team members can run integration tests regardless of OS, requires only the Chrome browser and ChromeDriver installation

- **Tests run successfully in browser**: Flutter's web driver works correctly for integration testing purposes, successfully simulated a user action and verified state of the program

4. **Flutter drive requires background process**: We need ChromeDriver running as a separate process on port 4444 before test is executed

## Decision

### Use Chrome for Integration Testing

Based on this spike we will use Chrome based integration tests for the main project rather than platform specific simulators so that:
- All team members can run tests without requiring platform specific dependencies
- We can have a consistent test environment across the team

## Implementation Guide

### 1. Check Chrome Version
Visit `chrome://settings/help` to find your chrome version

### 2. Install Matching ChromeDriver
```bash
npx @puppeteer/browsers install chromedriver@144 --path ~/.cache/puppeteer
```
replace 144 with your chrome version

### 3. Add Dependencies to pubspec.yaml
this can be done by running:
```bash
flutter pub add 'dev:integration_test:{"sdk":"flutter"}'
```

pubspec.yaml should now resemble something like:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

### 4. Create Test Environment
```bash
mkdir -p integration_test test_driver
```

Create `test_driver/integration_test.dart`:

add this to `integration_test.dart`:
```dart
import 'package:integration_test/integration_test_driver.dart';
Future<void> main() => integrationDriver();
```

### 5. Write the Integration Test
Create test files in `integration_test/` following the pattern:

```dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
// import your app

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user flow description', (tester) async {
    // this is where youd write the test 
  });
}
```

### 6. Run Tests
In one terminal start ChromeDriver and leave it running
```bash
npx chromedriver --port=4444
```
this is going to be different on windows and linux but i don't have those setup so i can't test it

In another terminal, run tests:
```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/[test_file].dart -d chrome
```

## Conclusion
terminal output should resemble this on passed test:

❯ flutter drive   --driver=test_driver/integration_test.dart   --target=integration_test/app_test.dart   -d chrome
Resolving dependencies... 
Downloading packages... 
  characters 1.4.0 (1.4.1 available)
  matcher 0.12.17 (0.12.18 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.17.0 (1.18.1 available)
  test_api 0.7.7 (0.7.9 available)
Got dependencies!
5 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
Launching integration_test/app_test.dart on Chrome in debug mode...
Waiting for connection from debug service on Chrome...              7.0s
This app is linked to the debug service: ws://127.0.0.1:50405/rAAP7Ed8YCM=/ws
Debug service listening on ws://127.0.0.1:50405/rAAP7Ed8YCM=/ws
A Dart VM Service on Chrome is available at: http://127.0.0.1:50405/rAAP7Ed8YCM=
The Flutter DevTools debugger and profiler on Chrome is available at: http://127.0.0.1:50405/rAAP7Ed8YCM=/devtools/?uri=ws://127.0.0.1:50405/rAAP7Ed8YCM=/ws
Starting application from main method in: org-dartlang-app:/web_entrypoint.dart.
00:00 +0: end-to-end test tap on the floating action button, verify counter
00:00 +1: (tearDownAll)
00:00 +2: All tests passed!
Application finished.