/// User-facing message with a stable localization key and optional arguments.
class UserMessage implements Exception {
  const UserMessage(this.key, [this.args = const {}]);

  final String key;
  final Map<String, Object?> args;

  @override
  String toString() => key;
}
