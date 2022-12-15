//
//  FindU.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/14.
//

import Foundation
import PathKit
import Rainbow

public struct UsageInfo {
    let className: String
    let totalCount: Int
    
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
        fatalError()
    }
    
    func getAllSwiftFile() -> Set<String> {
        let finder = ExtensionFindProcess(path: projectPath, extensions: ["swift"], excluded: swiftClasses)
        guard let result = finder?.execute() else {
            print("Resource finding failed.".red)
            return []
        }
        return result
    }
    
    func getAllOCFile() -> Set<String> {
        let finder = ExtensionFindProcess(path: projectPath, extensions: ["h", "m", "mm"], excluded: ocClasses)
        guard let result = finder?.execute() else {
            print("Resource finding failed.".red)
            return []
        }
        return result
    }
}
