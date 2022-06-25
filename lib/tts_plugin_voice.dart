class Voice {
  final String name;
  final String language;

  Voice({required this.name, required this.language});

  static Voice fromJson(dynamic json) {
    return Voice(
        name: json['name'] as String, language: json['language'] as String);
  }

  @override
  String toString() {
    return "name: $name, language: $language";
  }
}
