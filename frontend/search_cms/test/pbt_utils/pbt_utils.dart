import 'package:glados/glados.dart';

// Generally useful generators for use in Glados
// Property based testing

// Produces either a string, and empty string, or null
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

// Produces [upLimit, lowLimit] as a valid pair: either both 0, or upLimit <= lowLimit
extension AnyValidLimitRange on Any {
  Generator<List<int>> get validLimitRange => combine2(
    any.intInRange(0, null),
    any.intInRange(0, null),
    (a, b) => a <= b ? [a, b] : [b, a], // ensure ordering
  );
}

// Produces null or an int between 1-5 (for porosity)
extension AnyNullablePorosity on Any {
  Generator<int?> get nullablePorosity => any.either(
    any.intInRange(1, 6), // 1 inclusive, 6 exclusive = 1-5
    any.null_,
  );
}

// Produces [sizeUpper, sizeLower] as a valid pair: either both null, or sizeUpper >= sizeLower
extension AnyNullableValidSizeRange on Any {
  Generator<List<double?>> get nullableValidSizeRange => any.either(
    any.always([null, null]),              // both null case
    combine2(                              // both present, upper >= lower
      any.positiveDouble,
      any.positiveDouble,
      (a, b) => a >= b ? [a, b] : [b, a], // ensure ordering
    ),
  );
}

// Produces preExcavFrags, postExcavFrags, elements: all > 0
extension AnyValidTripleRange on Any {
  Generator<List<int>> get validTripleRange => combine3(
    any.intInRange(1, null),               // preExcavFrags > 0    
    any.intInRange(1, null),               // postExcavFrags > 0 
    any.intInRange(1, null),               // elements > 0
    (a, b, c) => [a, b, c],
  );
}



