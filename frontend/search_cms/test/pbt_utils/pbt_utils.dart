import 'package:glados/glados.dart';

// Generally useful generators for use in Glados
// Property based testing


// produces either a string, and empty string, or null
// call with 'nullableLetters'
// ex. Glados<String>().test('test_example', (nullableLetters) { ... });
extension MaybeAnyString on Any {
  // any.either randomly chooses between its two arguments
  Generator<String?> get nullableLetters => any.either(
    any.letters,  // string, can be empty
    any.null_,    // always null
  );
}

// Produces a valid Postgres UUID
// call with 'uuid'
// ex. Glados<String>().test('test_example', (uuid) { ... });
extension AnyUUID on Any {
  Generator<String> get uuid => any.simple(
    generate: (random, size) {
      const hexChars = '0123456789abcdef';
      // generate 32 random hex characters
      final chars = List.generate(32, (_) => hexChars[random.nextInt(16)]);
      final s = chars.join();
      // format into UUID shape 8-4-4-4-12
      return '${s.substring(0, 8)}-'
             '${s.substring(8, 12)}-'
             '${s.substring(12, 16)}-'
             '${s.substring(16, 20)}-'
             '${s.substring(20)}';
    },
    // there is no valuable shrink of a UUID so this statement prevents that
    shrink: (uuid) => [],
  );
}