import 'dart:convert';

class JwtToken {
  const JwtToken._();

  static bool isExpired(String token, {DateTime? now}) {
    try {
      final payload = decodeClaims(token);
      if (payload['exp'] is! num) {
        return true;
      }
      final expiry = DateTime.fromMillisecondsSinceEpoch(
        (payload['exp'] as num).toInt() * 1000,
      );
      return !expiry.isAfter(now ?? DateTime.now());
    } on FormatException {
      return true;
    }
  }

  static Map<String, dynamic> decodeClaims(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw const FormatException('Invalid JWT.');
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    if (payload is! Map<String, dynamic>) {
      throw const FormatException('Invalid JWT payload.');
    }
    return payload;
  }
}
