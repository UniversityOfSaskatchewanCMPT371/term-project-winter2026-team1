// ignore_for_file: unused_element

/*
Centralized Mockito mocks used across Authentication feature tests.

Keeping mocks in one place avoids duplicate @GenerateMocks blocks per test file
and makes build_runner output predictable and easy to regenerate.
To regenerate mocks : dart run build_runner build --delete-conflicting-outputs
*/

import 'package:mockito/annotations.dart';
import 'package:search_cms/features/authentication/data/data_sources/abstract_authentication_sign_in_api.dart';
import 'package:search_cms/features/authentication/domain/repositories/abstract_authentication_sign_in_repository.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_sign_in_usecase.dart';
import 'package:search_cms/features/authentication/domain/usecases/authentication_usecases.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateNiceMocks([
  // Clean architecture interfaces / domain objects
  MockSpec<AbstractAuthenticationSignInApi>(),
  MockSpec<AbstractAuthenticationSignInRepository>(),
  MockSpec<AuthenticationSignInUsecase>(),
  MockSpec<AuthenticationUsecases>(),

  // Supabase client + related types used by the API impl
  MockSpec<SupabaseClient>(),
  MockSpec<GoTrueClient>(),
  MockSpec<AuthResponse>(),
  MockSpec<Session>(),
  MockSpec<User>(),

  // PostgREST builder chain
  MockSpec<SupabaseQueryBuilder>(),
  MockSpec<PostgrestFilterBuilder<PostgrestList>>(),
])
void _generateMocks() {}