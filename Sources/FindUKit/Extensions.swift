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

public func += (left: inout [String : Int], right: [String : Int]) {
    for (k, v) in right {
        if left[k] != nil {
            left[k]! += v
        } else {
            left[k] = v
        }
    }
}
