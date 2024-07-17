import ProjectDescription

let config = Config(
    compatibleXcodeVersions: [.upToNextMinor("15.4.0"), .upToNextMinor("15.3.0"), .upToNextMinor("15.2.0")],
    swiftVersion: "5.10",
    generationOptions: .options(resolveDependenciesWithSystemScm: true, disablePackageVersionLocking: true)
)
