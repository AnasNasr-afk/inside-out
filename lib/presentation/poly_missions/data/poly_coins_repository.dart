import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:patient/core/helpers/shared_pref.dart';

/// Cross-device coin total for Poly missions.
///
/// Source of truth is Firestore at `poly_progress/{childId}`; SharedPrefs
/// (`pm_coins_$childId`) is kept as an offline mirror so the UI still works
/// without a network and so older installs — which only ever had the local
/// value — seed Firestore with their balance the first time they sync.
class PolyCoinsRepository {
  PolyCoinsRepository._();
  static final PolyCoinsRepository instance = PolyCoinsRepository._();

  static const String _coinsField = 'coins';

  String _prefsKey(int childId) => 'pm_coins_$childId';

  DocumentReference<Map<String, dynamic>> _doc(int childId) =>
      FirebaseFirestore.instance.collection('poly_progress').doc('$childId');

  /// Instant, synchronous local read for snappy first paint.
  int localCoins(int childId) => SharedPrefHelper.getInt(_prefsKey(childId));

  /// Authoritative coin total. Reads Firestore (which serves its cached value
  /// when offline) and falls back to the local mirror on failure. If the doc
  /// has no value yet but a local balance exists, seeds Firestore with it so a
  /// previously device-only total is preserved rather than reset to zero.
  Future<int> fetchCoins(int childId) async {
    if (childId <= 0) return 0;
    final local = localCoins(childId);
    debugPrint('🪙 [repo] fetchCoins childId=$childId, local mirror=$local');
    try {
      final snap = await _doc(childId).get();
      final remote = (snap.data()?[_coinsField] as num?)?.toInt();
      debugPrint('🪙 [repo] Firestore poly_progress/$childId → '
          'exists=${snap.exists}, coins=$remote, fromCache=${snap.metadata.isFromCache}');
      if (remote == null) {
        if (local > 0) {
          debugPrint('🪙 [repo] no remote value → SEEDING Firestore with '
              'local $local');
          await _doc(childId)
              .set({_coinsField: local}, SetOptions(merge: true));
        } else {
          debugPrint('🪙 [repo] no remote value and local is 0 → returning 0');
        }
        return local;
      }
      await SharedPrefHelper.setData(_prefsKey(childId), remote);
      debugPrint('🪙 [repo] using Firestore total=$remote (mirror updated)');
      return remote;
    } catch (e) {
      debugPrint('🪙 [repo] ⚠️ Firestore fetch FAILED → falling back to local '
          '$local. (Expected until the Firestore DB is created.) Error: $e');
      return local;
    }
  }

  /// Atomically adds [amount] coins across devices (via FieldValue.increment)
  /// and updates the local mirror immediately. [currentTotal] is the cubit's
  /// optimistic in-memory total used to keep the mirror in step right away.
  Future<void> addCoins(int childId, int amount, int currentTotal) async {
    if (childId <= 0) return;
    final optimistic = currentTotal + amount;
    await SharedPrefHelper.setData(_prefsKey(childId), optimistic);
    debugPrint('🪙 [repo] addCoins +$amount → local mirror now $optimistic, '
        'sending FieldValue.increment($amount) to poly_progress/$childId');
    try {
      await _doc(childId).set(
        {_coinsField: FieldValue.increment(amount)},
        SetOptions(merge: true),
      );
      debugPrint('🪙 [repo] Firestore increment OK for childId=$childId');
    } catch (e) {
      debugPrint('🪙 [repo] ⚠️ Firestore increment FAILED (kept locally at '
          '$optimistic). Error: $e');
    }
  }
}
