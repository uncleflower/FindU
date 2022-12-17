//
//  Extensions.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/16.
//

import Foundation
import PathKit

extension String {
    var ext: String {
        NSString(string: self).pathExtension
    }
    
    var cleanString: String {
        String(self.filter { !" \n\t\r".contains($0) })
    }
}

public func += (left: inout [UsageInfo], right: [UsageInfo]) {
    for leftUsage in left {
        for rightUsage in right {
            if leftUsage.className == rightUsage.className {
                leftUsage.totalCount += rightUsage.totalCount
                leftUsage.atFilePathes = leftUsage.atFilePathes.union(rightUsage.atFilePathes)
                break
            }
        }
    }
}
