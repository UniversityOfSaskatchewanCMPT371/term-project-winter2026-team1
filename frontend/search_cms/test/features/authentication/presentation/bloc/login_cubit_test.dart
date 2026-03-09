/*
Unit tests for LoginCubit state transitions.

These tests validate that LoginCubit emits the correct sequence of states
for success, failure, unknown results, and thrown exceptions.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search_cms/core/utils/class_templates/result.dart';
import 'package:search_cms/core/utils/constants.dart';
import 'package:search_cms/features/authentication/domain/entities/authentication_sign_in_result_classes.dart';
import 'package:search_cms/features/authentication/domain/entities/user_entity.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_cubit.dart';
import 'package:search_cms/features/authentication/presentation/bloc/login_state.dart';

import '../../mocks/authentication_mocks.mocks.dart';

// A Result subtype used to simulate unexpected Result variants in tests.
class UnknownResult extends Result {}

void main() {
  group('LoginCubit', () {
    setUp(() async {
      await getIt.reset();
    });

    tearDown(() async {
      await getIt.reset();
    });

    // Verifies the cubit emits [LoginLoading, LoginSuccess] when sign-in succeeds.
    test('LOGIN-CUBIT-1-emits loading then success on Success result', () async {
      final mockUsecases = MockAuthenticationUsecases();
      final mockSignIn = MockAuthenticationSignInUsecase();

      when(mockUsecases.authenticationSignInUsecase).thenReturn(mockSignIn);
      when(mockSignIn.call('abc@abc.com', '123456')).thenAnswer(
            (_) async => Success(userEntity: UserEntity(id: 'u1', role: Role.admin)),
      );

      getIt.registerSingleton<AuthenticationUsecases>(mockUsecases);

      final cubit = LoginCubit();

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const LoginLoading(),
          isA<LoginSuccess>(),
        ]),
      );

      await cubit.signIn(email: 'abc@abc.com', password: '123456');
      await expectation;

      expect(cubit.state, isA<LoginSuccess>());
      final success = cubit.state as LoginSuccess;
      expect(success.user.id, 'u1');
      expect(success.user.role, Role.admin);

      await cubit.close();
    });

    // Verifies the cubit emits [LoginLoading, LoginFailure] when domain Failure is returned.
    test('LOGIN-CUBIT-2-emits loading then failure on Failure result', () async {
      final mockUsecases = MockAuthenticationUsecases();
      final mockSignIn = MockAuthenticationSignInUsecase();

      when(mockUsecases.authenticationSignInUsecase).thenReturn(mockSignIn);
      when(mockSignIn.call('abc@abc.com', '123456')).thenAnswer(
            (_) async => Failure(errorMessage: 'bad creds'),
      );

      getIt.registerSingleton<AuthenticationUsecases>(mockUsecases);

      final cubit = LoginCubit();

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const LoginLoading(),
          const LoginFailure('bad creds'),
        ]),
      );

      await cubit.signIn(email: 'abc@abc.com', password: '123456');
      await expectation;

      expect(cubit.state, const LoginFailure('bad creds'));

      await cubit.close();
    });

    // Verifies the cubit emits an "unknown result" failure when Result type is unexpected.
    test('LOGIN-CUBIT-3-emits unknown-result failure when result is not Success/Failure', () async {
      final mockUsecases = MockAuthenticationUsecases();
      final mockSignIn = MockAuthenticationSignInUsecase();

      when(mockUsecases.authenticationSignInUsecase).thenReturn(mockSignIn);
      when(mockSignIn.call(any, any)).thenAnswer((_) async => UnknownResult());

      getIt.registerSingleton<AuthenticationUsecases>(mockUsecases);

      final cubit = LoginCubit();

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const LoginLoading(),
          const LoginFailure('Unknown authentication result'),
        ]),
      );

      await cubit.signIn(email: 'abc@abc.com', password: '123456');
      await expectation;

      expect(cubit.state, const LoginFailure('Unknown authentication result'));

      await cubit.close();
    });

    // Verifies the cubit emits a failure message when the usecase throws.
    test('LOGIN-CUBIT-4-emits failure when usecase throws', () async {
      final mockUsecases = MockAuthenticationUsecases();
      final mockSignIn = MockAuthenticationSignInUsecase();

      when(mockUsecases.authenticationSignInUsecase).thenReturn(mockSignIn);
      when(mockSignIn.call(any, any)).thenThrow(Exception('boom'));

      getIt.registerSingleton<AuthenticationUsecases>(mockUsecases);

      final cubit = LoginCubit();

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const LoginLoading(),
          isA<LoginFailure>(),
        ]),
      );

      await cubit.signIn(email: 'abc@abc.com', password: '123456');
      await expectation;

      expect(cubit.state, isA<LoginFailure>());
      expect((cubit.state as LoginFailure).message, contains('boom'));

      await cubit.close();
    });

    // Verifies reset() returns the cubit to LoginInitial state.
    test('LOGIN-CUBIT-5-reset emits LoginInitial', () async {
      final cubit = LoginCubit();

      cubit.reset();

      expect(cubit.state, const LoginInitial());
      await cubit.close();
    });
  });
}