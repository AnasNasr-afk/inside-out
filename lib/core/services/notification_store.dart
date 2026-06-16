import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';

/// Persistent, in-memory source of truth for the in-app notification list.
///
/// Reads/writes [SharedPreferences] directly via `getInstance()` (rather than
/// the cached [SharedPrefHelper]) so it also works from the FCM background
/// isolate, which never runs the app's `main()` initialisation.
class NotificationStore {
  NotificationStore._();
  static final NotificationStore instance = NotificationStore._();

  static const _prefsKey = 'app_notifications';
  static const _maxItems = 50;

  /// The current list, newest first. UI binds to this with a
  /// [ValueListenableBuilder].
  final ValueNotifier<List<AppNotification>> notifier = ValueNotifier(const []);

  List<AppNotification> get items => notifier.value;

  int get unreadCount => items.where((n) => !n.read).length;

  bool _loaded = false;

  /// Loads persisted notifications into memory. Safe to call multiple times.
  Future<void> init() async {
    if (_loaded) return;
    notifier.value = await _readFromDisk();
    _loaded = true;
  }

  /// Adds a notification (deduplicated by id), persists, and notifies the UI.
  /// Re-reads from disk first so foreground state stays in sync with anything
  /// the background isolate wrote while the app was backgrounded.
  Future<void> add(AppNotification notification) async {
    final current = await _readFromDisk();
    if (current.any((n) => n.id == notification.id)) {
      notifier.value = current;
      return;
    }
    final updated = [notification, ...current];
    if (updated.length > _maxItems) updated.removeRange(_maxItems, updated.length);
    await _writeToDisk(updated);
    notifier.value = updated;
  }

  /// Refreshes the in-memory list from disk (e.g. after returning to foreground).
  Future<void> refresh() async {
    notifier.value = await _readFromDisk();
  }

  Future<void> markAllRead() async {
    final current = await _readFromDisk();
    final updated = [for (final n in current) n.copyWith(read: true)];
    await _writeToDisk(updated);
    notifier.value = updated;
  }

  /// Marks a single notification read (e.g. when the user taps it).
  Future<void> markRead(String id) async {
    final current = await _readFromDisk();
    final updated = [
      for (final n in current) n.id == id ? n.copyWith(read: true) : n,
    ];
    await _writeToDisk(updated);
    notifier.value = updated;
  }

  /// Removes a single notification (e.g. swipe to dismiss).
  Future<void> remove(String id) async {
    final current = await _readFromDisk();
    final updated = current.where((n) => n.id != id).toList();
    await _writeToDisk(updated);
    notifier.value = updated;
  }

  Future<void> clear() async {
    await _writeToDisk(const []);
    notifier.value = const [];
  }

  // ── Disk helpers ───────────────────────────────────────────────────────────

  Future<List<AppNotification>> _readFromDisk() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null || raw.isEmpty) return const [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('⚠️ NotificationStore read failed: $e');
      return const [];
    }
  }

  Future<void> _writeToDisk(List<AppNotification> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _prefsKey,
        jsonEncode([for (final n in items) n.toJson()]),
      );
    } catch (e) {
      debugPrint('⚠️ NotificationStore write failed: $e');
    }
  }
}
