//
//  FileASTAnalyzer.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/16.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

protocol FileASTVisitor {
    typealias FileName = String
    typealias Count = Int
    
    var classNames: [String] { get }
    var filePath: String { get }
    func analyze() throws -> [FileName : Count]
}

// MARK: - SwiftAST
class SwiftASTVisitor: SyntaxVisitor, FileASTVisitor {
    var classNames: [String]
    var filePath: String
    var result = [FileName : Count]()
    
    init(classNames: [String], filePath: String) {
        self.classNames = classNames
        self.filePath = filePath
        super.init()
        _ = classNames.map { result[$0] = 0 }
    }
    
    override func visit(_ node: IdentifierExprSyntax) -> SyntaxVisitorContinueKind {
        // TODO: a littel weird, should optimize it
        _ = classNames.filter { node.description.cleanString == $0 }.map { result[$0]! += 1 }
        return .visitChildren
    }
    
    func analyze() throws -> [FileName : Count] {
        let treeURL = URL(fileURLWithPath: filePath)
        let tree = try SyntaxParser.parse(treeURL)
        self.walk(tree)
        return result
    }
}

// MARK: - OCAST
class OCASTVisitor: FileASTVisitor {
    var classNames: [String]
    var filePath: String
    
    init(classNames: [String], filePath: String) {
        self.classNames = classNames
        self.filePath = filePath
    }
    
    func analyze() throws -> [FileName : Count] {
        if classNames.isEmpty { return [:] }
        fatalError()
    }
}



