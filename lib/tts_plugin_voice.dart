class Voice {
  final String name;
  final String language;

  /// Internally used for identifying the voice
  final String handleName;

  Voice({required this.handleName, required this.name, required this.language});

  static Voice fromJson(dynamic json) {
    return Voice(
        handleName: json[_keyHandleName] as String,
        name: json[_keyName] as String,
        language: json[_keyLanguage] as String);
  }

  Map<String, dynamic> toJson() => {
        _keyHandleName: handleName,
        _keyName: name,
        _keyLanguage: language,
      };

  @override
  String toString() {
    return "name: $name, language: $language ($handleName)";
  }

  static const _keyHandleName = 'handleName';
  static const _keyName = 'name';
  static const _keyLanguage = 'language';
}
