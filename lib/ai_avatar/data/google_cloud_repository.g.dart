// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_cloud_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$googleCloudRepositoryHash() =>
    r'f95d87ba03d84ca8df205bcc84777c4ca61b6c1c';

/// See also [googleCloudRepository].
@ProviderFor(googleCloudRepository)
final googleCloudRepositoryProvider = Provider<GoogleCloudRepository>.internal(
  googleCloudRepository,
  name: r'googleCloudRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$googleCloudRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoogleCloudRepositoryRef = ProviderRef<GoogleCloudRepository>;
String _$voicesFutureHash() => r'6675c523d4477c80550b1c5db203a60d69ea05fa';

/// See also [voicesFuture].
@ProviderFor(voicesFuture)
final voicesFutureProvider = AutoDisposeFutureProvider<List<Voice>>.internal(
  voicesFuture,
  name: r'voicesFutureProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$voicesFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VoicesFutureRef = AutoDisposeFutureProviderRef<List<Voice>>;
String _$synthesizeTextFutureHash() =>
    r'1e607d720c7dfd0bd694710257c272a4e23b1cf3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [synthesizeTextFuture].
@ProviderFor(synthesizeTextFuture)
const synthesizeTextFutureProvider = SynthesizeTextFutureFamily();

/// See also [synthesizeTextFuture].
class SynthesizeTextFutureFamily extends Family<AsyncValue<ByteAudioSource>> {
  /// See also [synthesizeTextFuture].
  const SynthesizeTextFutureFamily();

  /// See also [synthesizeTextFuture].
  SynthesizeTextFutureProvider call(
    String text,
    String lang,
  ) {
    return SynthesizeTextFutureProvider(
      text,
      lang,
    );
  }

  @override
  SynthesizeTextFutureProvider getProviderOverride(
    covariant SynthesizeTextFutureProvider provider,
  ) {
    return call(
      provider.text,
      provider.lang,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'synthesizeTextFutureProvider';
}

/// See also [synthesizeTextFuture].
class SynthesizeTextFutureProvider
    extends AutoDisposeFutureProvider<ByteAudioSource> {
  /// See also [synthesizeTextFuture].
  SynthesizeTextFutureProvider(
    String text,
    String lang,
  ) : this._internal(
          (ref) => synthesizeTextFuture(
            ref as SynthesizeTextFutureRef,
            text,
            lang,
          ),
          from: synthesizeTextFutureProvider,
          name: r'synthesizeTextFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$synthesizeTextFutureHash,
          dependencies: SynthesizeTextFutureFamily._dependencies,
          allTransitiveDependencies:
              SynthesizeTextFutureFamily._allTransitiveDependencies,
          text: text,
          lang: lang,
        );

  SynthesizeTextFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.text,
    required this.lang,
  }) : super.internal();

  final String text;
  final String lang;

  @override
  Override overrideWith(
    FutureOr<ByteAudioSource> Function(SynthesizeTextFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SynthesizeTextFutureProvider._internal(
        (ref) => create(ref as SynthesizeTextFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        text: text,
        lang: lang,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ByteAudioSource> createElement() {
    return _SynthesizeTextFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SynthesizeTextFutureProvider &&
        other.text == text &&
        other.lang == lang;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, text.hashCode);
    hash = _SystemHash.combine(hash, lang.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SynthesizeTextFutureRef on AutoDisposeFutureProviderRef<ByteAudioSource> {
  /// The parameter `text` of this provider.
  String get text;

  /// The parameter `lang` of this provider.
  String get lang;
}

class _SynthesizeTextFutureProviderElement
    extends AutoDisposeFutureProviderElement<ByteAudioSource>
    with SynthesizeTextFutureRef {
  _SynthesizeTextFutureProviderElement(super.provider);

  @override
  String get text => (origin as SynthesizeTextFutureProvider).text;
  @override
  String get lang => (origin as SynthesizeTextFutureProvider).lang;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
