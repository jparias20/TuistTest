import Foundation
import ProjectDescription

public extension Project {
    static func projectRootPath() -> String {
        var pathComponents = URL(fileURLWithPath: #file).pathComponents
        pathComponents = Array(pathComponents.prefix(pathComponents.count - 4))
        if pathComponents.first == "/" {
            pathComponents = Array(pathComponents.dropFirst())
        }
        let path = pathComponents.joined(separator: "/")
        return "/\(path)"
    }
}

public extension Project {
    static let sampleAppBasePropertyList: [String: Plist.Value] = [:]
}
