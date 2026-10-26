/// Checks that the core is reachable and returns its versions.
const systemPing = 'system.ping';

final class PingResult {
  const PingResult({required this.serverVersion, required this.apiVersion});

  factory PingResult.fromJson(Map<String, Object?> json) =>
      PingResult(serverVersion: json['server_version']! as String, apiVersion: json['api_version']! as String);

  final String serverVersion;
  final String apiVersion;
}
