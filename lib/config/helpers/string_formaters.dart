class StringFormaters {
  StringFormaters._();

  static String messageIdParser(String messageId) {
    if (messageId.isEmpty) return messageId;
    return messageId.replaceAll(":", "").replaceAll('%', '');
  }
}
