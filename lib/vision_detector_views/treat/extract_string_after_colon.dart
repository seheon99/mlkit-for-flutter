class ExtractStringAfterColon {
  static String extract(String text) {
    final parts = text.split(':');
    if (parts.length > 1) {
      return parts[1].trim();
    }
    final part2 = text.split('교환처');
    if (part2.length > 1) {
      return part2[1].trim();
    }
    final part3 = text.split('사용처');
    if (part3.length > 1) {
      return part3[1].trim();
    }
    return text;
  }
}
