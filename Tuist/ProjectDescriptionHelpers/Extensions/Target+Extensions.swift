import Foundation
import ProjectDescription

public extension Target {
    static func iOSLibrary(
        name: String,
        bundleId: String,
        dependencies: [ProjectDescription.TargetDependency] = [],
        organizationName: String,
        developmentTeam: String
    ) -> Target {
        Target.target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: bundleId,
            deploymentTargets: iOSDeploymentTarget,
            infoPlist: .default,
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            scripts: [TargetScript.checkAPI],
            dependencies: dependencies,
            settings: Settings.librarySettings(
                organizationName: organizationName,
                developmentTeam: developmentTeam
            ),
            mergedBinaryType: .disabled,
            mergeable: true
        )
    }
    
    static func tests(
        for target: Target,
        hostingApp: Target? = nil
    ) -> Target {
        var dependencies = [TargetDependency.target(name: target.name)]
        if let hostingApp {
            dependencies.append(TargetDependency.target(name: hostingApp.name))
        }
        
        return Target.target(
            name: "\(target.name)Tests",
            destinations: target.destinations,
            product: .unitTests,
            bundleId: "\(target.bundleId).Tests",
            infoPlist: .default,
            sources: ["\(target.name)/Tests/**"],
            resources: [],
            dependencies: dependencies
        )
    }
    
    static func iOSSampleApp(
        for target: Target,
        dependencies: [ProjectDescription.TargetDependency] = [],
        organizationName: String,
        developmentTeam: String
    ) -> Target? {
        if Environment.isCI.getBoolean(default: false) {
            return nil // No Sample Apps on CI until we have provisioning profiles
        }
        return Target.target(
            name: "SampleApp",
            destinations: .iOS,
            product: .app,
            bundleId: target.bundleId + ".sampleApp",
            deploymentTargets: iOSDeploymentTarget,
            infoPlist: .extendingDefault(with: Project.sampleAppBasePropertyList),
            sources: ["SampleApp/Sources/**"],
            resources: ["SampleApp/Resources/**"],
            dependencies: dependencies,
            settings: Settings.sampleAppSettings(
                organizationName: organizationName,
                developmentTeam: developmentTeam
            )
        )
    }
}

private extension Target {
    static func exploreDirectory(atPath path: String,
                                 inResourceFolder resourceFolder: String,
                                 resources: inout [ResourceFileElement]) {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: path)
            for element in directoryContents {
                let elementPath = "\(path)/\(element)"
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: elementPath, isDirectory: &isDirectory) {
                    if elementPath.hasSuffix("xcassets") || elementPath.hasSuffix("xcstrings") {
                        resources.append(ResourceFileElement(stringLiteral: "\(resourceFolder)/\(element)"))
                    } else if isDirectory.boolValue {
                        // Recursively explore subdirectories
                        exploreDirectory(atPath: elementPath, inResourceFolder: "\(resourceFolder)/\(element)", resources: &resources)
                    } else {
                        if !(element.hasSuffix(".swift") || element.hasSuffix("gitkeep")) {
                            resources.append(ResourceFileElement(stringLiteral: "\(resourceFolder)/\(element)"))
                        }
                    }
                }
            }
        } catch {
            // Handle error
        }
    }
    
    static func resources(in resourceFolder: String) -> [ResourceFileElement]? {
        guard let projectUrl = URL(string: Project.projectRootPath()) else {
            return nil
        }
        let path = "\(projectUrl.absoluteString)/\(resourceFolder)"
        if !FileManager.default.fileExists(atPath: path) {
            return nil
        }
        var resources = [ResourceFileElement]()
        exploreDirectory(atPath: path, inResourceFolder: resourceFolder, resources: &resources)
        if resources.isEmpty {
            return nil
        }
        return resources
    }
}
