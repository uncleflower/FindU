//
//  FindUKitSpec.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/15.
//

import Foundation
@testable import FindUKit
import Spectre
import PathKit

public let testFindUKit: ((ContextType) -> Void) = {
    let fixtures = Path(#file).parent().parent() + "Fixtures"
    
    $0.describe("File path ext") {
        $0.it("should print swift") {
            let filePath = fixtures + "FullProcess" + "FullProcess1.swift"
            let result = filePath.extension
            let expected = "swift"
            try expect(result) == expected
        }
    }
    
    $0.describe("swift process test") {
        $0.it("swift process") {
            let filePath = fixtures + "FullProcess"
            let findU = FindU(projectPath: filePath.string,
                              swiftClasses: ["TargetClass", "TargetClass2"],
                              ocClasses: [],
                              searchInFileExt: ["h", "m", "mm", "swift"])
            
            
            let usageInfo = findU.getTotalUsage()
            _ = usageInfo.map { info in
                print("ClassName: \(info.className) Totoal: \(info.totalCount)")
            }
        }
    }
}

