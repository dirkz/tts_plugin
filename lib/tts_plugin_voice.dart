class Voice {
  final String name;
  final String language;

  /// Internally used for identifying the voice
  final String handleName;

  Voice({required this.handleName, required this.name, required this.language});

  static Voice fromJson(dynamic json) {
    return Voice(
        handleName: json['handleName'] as String,
        name: json['name'] as String,
        language: json['language'] as String);
  }

  Map<String, dynamic> toJson() => {
        'handleName': handleName,
        'name': name,
        'language': language,
      };

  @override
  String toString() {
    return "name: $name, language: $language ($handleName)";
  }
}
