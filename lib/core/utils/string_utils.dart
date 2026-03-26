class StringUtils {
  static String maskData(String data) {
    if (data.contains('@')) {
      final parts = data.split('@');
      final username = parts[0];
      final domain = parts[1];

      if (username.length > 2) {
        return '${username.substring(0, 2)}****@$domain';
      }
      return data;
    } else {
      if (data.length > 8) {
        String start = data.substring(0, 4);
        String end = data.substring(data.length - 3);
        return '$start *** ** $end';
      }
      return data;
    }
  }
}
