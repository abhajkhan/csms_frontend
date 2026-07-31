class ApiConfig {
  const ApiConfig._();

  static const connectTimeout = Duration(seconds: 20);
  static const receiveTimeout = Duration(seconds: 20);
  static const sendTimeout = Duration(seconds: 20);
  static const contentType = 'application/json';
}
