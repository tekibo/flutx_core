class PackageStructure {
  final String name;
  final String? version;
  final String? url;
  final String? path;
  final String? ref;
  final bool isDev;
  final bool isGit;

  PackageStructure({
    required this.name,
    this.version,
    this.url,
    this.path,
    this.ref,
    this.isDev = false,
    this.isGit = false,
  });
}
