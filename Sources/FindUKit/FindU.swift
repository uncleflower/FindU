//
//  FindU.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/14.
//

import Foundation
import PathKit
import Rainbow

enum FileType {
    case swift
    case objc
    
    init?(ext: String) {
        switch ext {
        case "swift": self = .swift
        case "h", "m", "mm": self = .objc
        default: return nil
        }
    }
    
    func fileASTAnalyzer(swiftClasses: [String], ocClasses: [String], in filePath: String) -> FileASTVisitor {
        switch self {
        case .swift:
            return SwiftASTVisitor(classNames: swiftClasses, filePath: filePath)
        case .objc:
            return OCASTVisitor(classNames: ocClasses, filePath: filePath)
        }
    }
}

public class UsageInfo {
    public let className: String
    public var totalCount: Int
    public var atFilePathes = Set<String>()
    
    init(className: String, totalCount: Int, inFilePaths: Set<String> = []) {
        self.className = className
        self.totalCount = totalCount
        self.atFilePathes = inFilePaths
    }
}

public struct FindU {
    let projectPath: Path
    let swiftClasses: [String]
    let ocClasses: [String]
    let searchInFileExt: [String]
    var result: [UsageInfo] = []
    
    public init(projectPath: String, swiftClasses: [String], ocClasses: [String], searchInFileExt: [String]) {
        self.projectPath = Path(projectPath).absolute()
        self.swiftClasses = swiftClasses
        self.ocClasses = ocClasses
        self.searchInFileExt = searchInFileExt
    }
    
    public func getTotalUsage() -> [UsageInfo] {
        let emptyUsageInfo = (swiftClasses + ocClasses.filter { !swiftClasses.contains($0) })
            .map { UsageInfo(className: $0, totalCount: 0) }
        return searchAllFilePathes().reduce(into: emptyUsageInfo) { curResult, filePath in
            curResult += analyzeFile(filePath: filePath)
        }
    }
    
    func searchAllFilePathes() -> Set<String> {
        let finder = ExtensionFindProcess(path: projectPath, extensions: searchInFileExt, excluded: swiftClasses + ocClasses)
        guard let result = finder?.execute() else {
            print("Files finding failed.".red)
            return []
        }
        return result
    }
    
    func analyzeFile(filePath: String) -> [UsageInfo] {
        guard let fileType = FileType(ext: filePath.ext) else { return [] }
        let analyzer = fileType.fileASTAnalyzer(swiftClasses: swiftClasses, ocClasses: ocClasses, in: filePath)
        let classCountRes = (try? analyzer.analyze()) ?? [:]
        return classCountRes.map {
            return UsageInfo(className: $0.key,
                             totalCount: $0.value,
                             inFilePaths: ($0.value != 0) ? [filePath] : [])
        }
    }
}
