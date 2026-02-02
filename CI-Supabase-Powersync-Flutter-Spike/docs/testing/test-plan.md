# Testability Plan

**Last Updated:** 2026-01-22

## Unit Tests
Flutter has a built in testing package called flutter_test that will be used to create unit tests. Under this package, each class gets a matching class_test file containing mock instances of that class and appropriate unit tests of any methods within the class. These tests are created by the developers who made the original code and will be an important item of review during formal and informal inspections. Tests should be written prior to developing the actual code to follow the Test Driven Development model and should make use of the 'expect' keyword to create assertions.
References can be found [here](https://docs.flutter.dev/cookbook/testing/unit/introduction)

## Integration Tests
The unit testing model also allows for grouping multiple tests together. This is known as 'widget testing' in the Flutter documentation. See previous reference page.

## System Tests
Our system uses a locally hosted database. This allows for full simulation of data entry and querying. Todo this we can leverage Supabase integrated testing using pgTAP and direct API calls from Flutter.
Don't currently have any direct references for this.

## UI Tests
A number of UI testing tools exist for Flutter applications. A promising option is flutter_test_pilot, which can automatically detect and navigate through different widgets and is published on the Flutter developer documentation page.
References to this tool can be found [here](https://pub.dev/packages/flutter_test_pilot)
