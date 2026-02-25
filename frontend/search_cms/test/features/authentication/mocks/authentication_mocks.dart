/// Centralized Mockito mocks for the Authentication feature.
///
/// After adding/updating mocks, regenerate with:
///   flutter pub run build_runner build --delete-conflicting-outputs
library authentication_mocks;

import 'package:mockito/annotations.dart';
import 'package:search_cms/features/authentication/data/data_sources/abstract_authentication_sign_in_api.dart';
import 'package:search_cms/features/authentication/domain/repositories/abstract_authentication_sign_in_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_mocks.mocks.dart';

@GenerateNiceMocks([
  // Clean-architecture interfaces
  MockSpec<AbstractAuthenticationSignInApi>(),
  MockSpec<AbstractAuthenticationSignInRepository>(),

  // Supabase classes used by AuthenticationSignInApiImpl
  MockSpec<SupabaseClient>(),
  MockSpec<GoTrueClient>(),
  MockSpec<AuthResponse>(),
  MockSpec<Session>(),
  MockSpec<User>(),
  MockSpec<SupabaseQueryBuilder>(),
  MockSpec<PostgrestFilterBuilder<PostgrestList>>(),
])
void _generateMocks() {}