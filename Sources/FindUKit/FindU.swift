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
        var result: [UsageInfo] = []
        let swiftFiles = getAllSwiftFiles()
        let ocFiles = getAllOCFiles()
        
        result.append(contentsOf: swiftClasses.map { countUsage(className: $0, filePaths: swiftFiles) })
        result.append(contentsOf: ocClasses.map { countUsage(className: $0, filePaths: ocFiles) })
        return result
    }
    
    func getAllSwiftFiles() -> Set<String> {
        let finder = ExtensionFindProcess(path: projectPath, extensions: ["swift"], excluded: swiftClasses)
        guard let result = finder?.execute() else {
            print("Swift files finding failed.".red)
            return []
        }
        return result
    }
    
    func getAllOCFiles() -> Set<String> {
        let finder = ExtensionFindProcess(path: projectPath, extensions: ["h", "m", "mm"], excluded: ocClasses)
        guard let result = finder?.execute() else {
            print("OC files finding failed.".red)
            return []
        }
        return result
    }
    
    func countUsage(className: String, filePaths: Set<String>) -> UsageInfo {
        let totalCount = filePaths.lazy.map { Path($0) }.reduce(0, { curCount, path in
            let content = (try? path.read()) ?? ""
            return curCount + counter(target: className, content: content)
        })
        
        return UsageInfo(className: className, totalCount: totalCount)
    }
    
    func counter(target: String, content: String) -> Int {
        var count = 0
        let nsstring = NSString(string: content)
        var searchRange = NSRange(location: 0, length: nsstring.length)
        var foundRange = nsstring.range(of: target, range: searchRange)
        while foundRange.location != NSNotFound {
            count += 1
            searchRange = NSRange(location: foundRange.upperBound, length: nsstring.length - foundRange.upperBound)
            foundRange = nsstring.range(of: target, range: searchRange)
        }
        return count
    }
}
