class Env {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);
}
