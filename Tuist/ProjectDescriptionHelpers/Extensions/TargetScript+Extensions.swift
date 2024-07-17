import ProjectDescription

public extension TargetScript {
//    static var swiftlint: TargetScript = {
//        return TargetScript.pre(
//            path: "Scripts/swiftlint.sh",
//            arguments: [],
//            name: "Swiftlint",
//            basedOnDependencyAnalysis: false
//        )
//    }()

    static var checkAPI: TargetScript = {
        return TargetScript.pre(
            path: "Scripts/check_api.sh",
            arguments: [Project.projectRootPath()],
            name: "Check API",
            basedOnDependencyAnalysis: false
        )
    }()
}
