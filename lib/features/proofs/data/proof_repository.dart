import 'package:flutter/foundation.dart';

import '../domain/proof.dart';
import '../domain/proof_repository.dart' as domain;
import 'proof_local_datasource.dart';

class ProofRepository extends ChangeNotifier implements domain.ProofRepository {
  ProofRepository._({ProofLocalDatasource? datasource})
      : _datasource = datasource ?? ProofLocalDatasource();

  static final ProofRepository instance = ProofRepository._();

  final ProofLocalDatasource _datasource;
  List<Proof> _proofs = [];

  @override
  List<Proof> get proofs => List.unmodifiable(_proofs);

  @override
  List<Proof> get recentProofs {
    final sorted = List<Proof>.from(_proofs)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(6).toList();
  }

  @override
  List<Proof> get favoriteProofs =>
      _proofs.where((p) => p.isFavorite).toList();

  @override
  int get totalCount => _proofs.length;

  static bool _isLegacySeed(Proof p) =>
      p.id.startsWith('seed-') || p.fileRef.originalPath.startsWith('demo/');

  @override
  Future<void> initialize() async {
    _proofs = await _datasource.loadProofs();
    final cleaned = _proofs.where((p) => !_isLegacySeed(p)).toList();
    if (cleaned.length != _proofs.length) {
      _proofs = cleaned;
      await _datasource.saveProofs(_proofs);
    }
    notifyListeners();
  }

  @override
  Proof? getById(String id) {
    try {
      return _proofs.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addProof(Proof proof) async {
    _proofs.insert(0, proof);
    await _datasource.saveProofs(_proofs);
    notifyListeners();
  }

  @override
  Future<void> updateProof(Proof proof) async {
    final index = _proofs.indexWhere((p) => p.id == proof.id);
    if (index != -1) {
      _proofs[index] = proof;
      await _datasource.saveProofs(_proofs);
      notifyListeners();
    }
  }

  @override
  Future<void> deleteProof(String id) async {
    _proofs.removeWhere((p) => p.id == id);
    await _datasource.saveProofs(_proofs);
    notifyListeners();
  }

  @override
  Future<void> clearClassificationForClient(
    String clientId,
    Set<String> siteIds,
  ) async {
    var changed = false;
    for (var i = 0; i < _proofs.length; i++) {
      final p = _proofs[i];
      final hit = p.clientId == clientId ||
          (p.siteMissionId != null && siteIds.contains(p.siteMissionId));
      if (hit) {
        _proofs[i] = p.copyWith(clientId: null, siteMissionId: null);
        changed = true;
      }
    }
    if (changed) {
      await _datasource.saveProofs(_proofs);
      notifyListeners();
    }
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final proof = getById(id);
    if (proof != null) {
      await updateProof(proof.copyWith(isFavorite: !proof.isFavorite));
    }
  }

  @override
  List<Proof> filterByType(ProofType type) =>
      _proofs.where((p) => p.proofType == type).toList();
}
