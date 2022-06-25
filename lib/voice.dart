class Voice {
  final String name;
  final String language;

  /// Internally used for identifying the voice
  final String voiceURL;

  Voice({required this.voiceURL, required this.name, required this.language});

  static Voice fromJson(dynamic json) {
    return Voice(
        voiceURL: json[_keyVoiceURL] as String,
        name: json[_keyName] as String,
        language: json[_keyLanguage] as String);
  }

  Map<String, dynamic> toJson() => {
        _keyVoiceURL: voiceURL,
        _keyName: name,
        _keyLanguage: language,
      };

  @override
  String toString() {
    return "$name, ($language) [$voiceURL]";
  }

  static const _keyVoiceURL = 'voiceURL';
  static const _keyName = 'name';
  static const _keyLanguage = 'language';
}
