class VersionInfo {
  final String version;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;

  VersionInfo({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
    this.forceUpdate = false,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      version: json['version'],
      downloadUrl: json['downloadUrl'],
      releaseNotes: json['releaseNotes'],
      forceUpdate: json['forceUpdate'] ?? false,
    );
  }
}
