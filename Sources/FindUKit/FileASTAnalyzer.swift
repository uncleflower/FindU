//
//  FileASTAnalyzer.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/16.
//

import Foundation
import PathKit
import SwiftSyntax
import SwiftSyntaxParser

protocol FileASTVisitor {
    typealias ClassName = String
    typealias Count = Int
    
    var classNames: [String] { get }
    var filePath: String { get }
    
    func analyze() throws -> [ClassName : Count]
}

// MARK: - SwiftAST
class SwiftASTVisitor: SyntaxVisitor, FileASTVisitor {
    var classNames: [String]
    var filePath: String
    var result = [ClassName : Count]()
    
    init(classNames: [String], filePath: String) {
        self.classNames = classNames
        self.filePath = filePath
        super.init()
        _ = classNames.map { result[$0] = 0 }
    }
    
    override func visit(_ node: IdentifierExprSyntax) -> SyntaxVisitorContinueKind {
        _ = classNames.filter { node.identifier.text.cleanString == $0 }.map {
            result[$0]! += 1
        }
        return .visitChildren
    }
    
    func analyze() throws -> [ClassName : Count] {
        guard !classNames.isEmpty else { return [:] }
        let treeURL = URL(fileURLWithPath: filePath)
        do {
            let tree = try SyntaxParser.parse(treeURL)
            self.walk(tree)
        } catch {
            print("Fail to analyze file: \(filePath)".red)
        }
        return result
    }
}

// MARK: - OCAST
class OCASTVisitor: FileASTVisitor {
    var classNames: [String]
    var filePath: String
    var result = [ClassName : Count]()
    
    init(classNames: [String], filePath: String) {
        self.classNames = classNames
        self.filePath = filePath
        _ = classNames.map { result[$0] = 0 }
    }
    
    // TODO: Use regular expression, check whether it needs to be changed to AST.
    func analyze() throws -> [ClassName : Count] {
        guard !classNames.isEmpty else { return [:] }
        let content = (try? Path(filePath).read()) ?? ""
        _ = try classNames.map { className in
            let regex = "\\[\(className) "
            let re = try NSRegularExpression(pattern: regex, options: [])
            let matchs = re.matches(in: content, options: .reportProgress, range: NSRange(location: 0, length: content.count))
            result[className] = matchs.count
        }
        return result
    }
}



