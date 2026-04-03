import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stampsight/core/di/providers.dart';
import 'package:stampsight/features/clients/data/clients_repository.dart'
    as clients_impl;
import 'package:stampsight/features/proofs/data/proof_repository.dart'
    as proof_impl;
import 'package:stampsight/features/session/domain/active_session_notifier.dart';

void main() {
  test('repository providers expose same singletons as .instance', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(proofRepositoryProvider),
      same(proof_impl.ProofRepository.instance),
    );
    expect(
      container.read(proofRepositoryListenableProvider),
      same(proof_impl.ProofRepository.instance),
    );
    expect(
      container.read(clientsRepositoryProvider),
      same(clients_impl.ClientsRepository.instance),
    );
    expect(
      container.read(activeSessionRepositoryProvider),
      same(ActiveSessionNotifier.instance),
    );
  });
}
