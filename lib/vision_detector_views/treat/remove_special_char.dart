class RemoveSpecialChar {
  String run(String input) {
    final String pattern = r"[^a-zA-Z0-9_가-힣\s+\/&.]+";
    return input.replaceAll(RegExp(pattern), "");
  }
}
