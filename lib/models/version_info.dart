class VersionInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;
  final String? minVersion;
  final String? publishTime;

  VersionInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
    this.forceUpdate = false,
    this.minVersion,
    this.publishTime,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      version: json['version'],
      downloadUrl: json['downloadUrl'],
      releaseNotes: json['releaseNotes'],
      forceUpdate: json['forceUpdate'] ?? false,
      minVersion: json['minVersion'],
      publishTime: json['publishTime'],
    );
  }
}
