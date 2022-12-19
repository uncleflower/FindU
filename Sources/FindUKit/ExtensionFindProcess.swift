//
//  ExtensionFindProcess.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/15.
//

import Foundation
import PathKit

class ExtensionFindProcess: NSObject {
    let find: Process
    let grep: Process
    
    init?(path: Path, extensions: [String], excludeClasses: [String]) {
        do {
            find = Process()
            find.launchPath = "/usr/bin/find"
            guard !extensions.isEmpty else {
                return nil
            }
            
            var args: [String] = []
            args.append(path.string)
            
            for (idx, ext) in extensions.enumerated() {
                if idx != 0 {
                    args.append("-or")
                }
                args.append(contentsOf: ["-name", "*.\(ext)"])
            }
            
            find.arguments = args
        }
        
        do {
            grep = Process()
            grep.launchPath = "/usr/bin/grep"
            guard !excludeClasses.isEmpty else { return nil }
            var excludeArg = ""
            for (idx, className) in excludeClasses.enumerated() {
                if idx != 0 {
                    excludeArg.append(#"\|"#)
                }
                excludeArg.append(className)
            }
            
            let args = ["-wv", excludeArg]
            grep.arguments = args
        }
    }
    
    convenience init?(path: String, extensions: [String], excludeClasses: [String]) {
        self.init(path: Path(path), extensions: extensions, excludeClasses: excludeClasses)
    }
    
    func execute() -> Set<String> {
        let pipe = Pipe()
        find.standardOutput = pipe
        grep.standardInput = pipe
        
        let output = Pipe()
        grep.standardOutput = output

        find.launch()
        grep.launch()
        
        let data = output.fileHandleForReading.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            return Set(string.components(separatedBy: "\n").dropLast())
        } else {
            return []
        }
    }
}
