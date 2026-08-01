import 'package:csms_frontend/features/auth/models/jwt_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('invalid JWT is treated as expired', () {
    expect(JwtToken.isExpired('not-a-jwt'), isTrue);
  });
}
