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

public struct UsageInfo {
    public let className: String
    public let totalCount: Int
    
    init(className: String, totalCount: Int) {
        self.className = className
        self.totalCount = totalCount
    }
}

public struct FindU {
    let projectPath: Path
    let swiftClasses: [String]
    let ocClasses: [String]
    let searchInFileExt: [String]
    
    public init(projectPath: String, swiftClasses: [String], ocClasses: [String], searchInFileExt: [String]) {
        self.projectPath = Path(projectPath).absolute()
        self.swiftClasses = swiftClasses
        self.ocClasses = ocClasses
        self.searchInFileExt = searchInFileExt
    }
    
    public func getTotalUsage() -> [UsageInfo] {
        return searchAllFilePathes().reduce(into: [:]) { curResult, filePath in
            curResult += analyzeFile(filePath: filePath)
        }.map {
            UsageInfo(className: $0, totalCount: $1)
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
    
    func analyzeFile(filePath: String) -> [String : Int] {
        guard let fileType = FileType(ext: filePath.ext) else { return [:] }
        let analyzer = fileType.fileASTAnalyzer(swiftClasses: swiftClasses, ocClasses: ocClasses, in: filePath)
        return (try? analyzer.analyze()) ?? [:]
    }
}
