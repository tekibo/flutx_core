class Rgx {
  static bool isCopiedFromPubDevButton(String package) =>
      RegExp(r'^.*?:\s+.*?$').hasMatch(package);
  static bool isCopiedFromPubDevDirectly(String package) =>
      RegExp(r'^.*?\s+.*?$').hasMatch(package);
  static bool isSelfWritten(String package) =>
      RegExp(r'^.*?:\s+.*?$').hasMatch(package);

  static splitCopiedFromPubDevButton(String package) =>
      RegExp(r'^(.*?):\s+(.*?)$').firstMatch(package);
  static splitCopiedFromPubDevDirectly(String package) =>
      RegExp(r'^(.*?)\s+(.*?)$').firstMatch(package);
  static splitSelfWritten(String package) =>
      RegExp(r'^(.*?):\s+(.*?)$').firstMatch(package);
}
