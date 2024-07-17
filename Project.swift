import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let KingfisherPackage = Package.remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.12.0"))

let libraryName = "TuistTestLibrary"
let organizationName = "Chontas" // Apple ID Team Name
let developmentTeam = "" // Apple Team ID

let bundleId = "jparias.com.lib.\(libraryName)"

let framework = Target.iOSLibrary(
    name: libraryName,
    bundleId: bundleId,
    organizationName: organizationName,
    developmentTeam: developmentTeam
)

let sampleApp = Target.iOSSampleApp(
    for: framework,
    dependencies: [.target(framework)],
    organizationName: organizationName,
    developmentTeam: developmentTeam
)
let unitTests = Target.tests(
    for: framework,
    hostingApp: sampleApp
)

//let framework = Target.target(
//    name: libraryName,
//    destinations: .iOS,
//    product: .dynamicLibrary,
//    bundleId: bundleId,
//    deploymentTargets: iOSDeploymentTarget,
//    infoPlist: .default,
//    sources: ["\(libraryName)/Sources/**"],
//    resources: ["\(libraryName)/Resources/**"],
//    dependencies: [
//
//    ]
//)
//
//let unitTests = Target.target(
//    name: "\(libraryName)Tests",
//    destinations: .iOS,
//    product: .unitTests,
//    bundleId: bundleId + ".Tests",
//    infoPlist: .default,
//    sources: ["\(libraryName)/Tests/**"],
//    resources: [],
//    dependencies: [.target(name: "TuistTestLibrary")]
//)
//
//let sampleApp = Target.target(
//    name: "SampleApp",
//    destinations: .iOS,
//    product: .app,
//    bundleId: bundleId + ".SampleApp",
//    infoPlist: .default,
//    sources: ["SampleApp/\(libraryName)/Sources/**"],
//    resources: [],
//    dependencies: [.target(name: "TuistTestLibrary")]
//)

let project = Project(
    name: libraryName,
    organizationName: organizationName,
    options: Project.Options.options(
        automaticSchemesOptions: .enabled(
            targetSchemesGrouping: .notGrouped,
            codeCoverageEnabled: true,
            testingOptions: .parallelizable
        )
    ),
    settings: Settings.librarySettings(
        organizationName: organizationName,
        developmentTeam: developmentTeam
    ),
    targets: [framework, unitTests, sampleApp].compactMap { $0 },
    schemes: [
        Scheme.scheme(
            name: framework.name,
            shared: true,
            buildAction: BuildAction.buildAction(targets: [.target(framework.name)]),
            testAction: TestAction.targets(
                [.testableTarget(target: .target(unitTests.name))],
                arguments: nil,
                configuration: .debug,
                options: .options(coverage: true,codeCoverageTargets: [.target(framework.name)]),
                diagnosticsOptions: .options(mainThreadCheckerEnabled: true)
            ),
            runAction: RunAction.runAction(configuration: .debug)
        ),
        Scheme.sampleAppScheme(for: sampleApp)
        
    ].compactMap { $0 }
)


//let project = Project(
//    name: libraryName,
//    options: .options(
//        automaticSchemesOptions: .enabled(
//            targetSchemesGrouping: .notGrouped,
//            codeCoverageEnabled: true,
//            testingOptions: .parallelizable
//        )
//    ),
//    targets: [
//        framework,
//        unitTests,
//        sampleApp
//    ]
//)
