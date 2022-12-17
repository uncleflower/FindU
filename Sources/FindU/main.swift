//
//  main.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/14.
//

import Foundation
import CommandLineKit
import Rainbow
import FindUKit

let appVersion = "0.0.1"

let cli = CommandLineKit.CommandLine()
let projectPathOption = StringOption(
    shortFlag: "p", longFlag: "path", required: false,
    helpMessage: "Root path of your project. Default is current folder.")
cli.addOption(projectPathOption)

let classesOption = MultiStringOption(
    shortFlag: "c", longFlag: "classes", required: false,
    helpMessage: "Class name in both Swift and Objective-C")
cli.addOption(classesOption)

let swiftClassOption = MultiStringOption(
    shortFlag: "s", longFlag: "swift-classes", required: false,
    helpMessage: "Class names in Swift")
cli.addOption(swiftClassOption)

let ocClassOption = MultiStringOption(
    shortFlag: "o", longFlag: "oc-classes", required: false,
    helpMessage: "Class names in Objective-C")
cli.addOption(ocClassOption)

let fileExtOption = MultiStringOption(
    shortFlag: "f", longFlag: "file-extensions", required: false,
    helpMessage: "In which type of file you search for usage, defualt is 'h m mm swift'")
cli.addOption(fileExtOption)

let printFmtOption = StringOption(
    longFlag: "print-format", required: false,
    helpMessage: "Customize the print format. You can pass Class:<C> Totoal:<T> Paths:<P>. <C> will be replaced by class name, <T> will be replaced by total count, <P> will be replaced by file pathes")
cli.addOption(printFmtOption)

let versionOption = BoolOption(
    shortFlag: "v", longFlag: "version",
    helpMessage: "Print version.")
cli.addOption(versionOption)

let helpOption = BoolOption(
    shortFlag: "h", longFlag: "help",
    helpMessage: "Print this help message.")
cli.addOption(helpOption)

do {
  try cli.parse()
} catch {
  cli.printUsage(error)
  exit(EX_USAGE)
}

if !cli.unparsedArguments.isEmpty {
    print("Unknow arguments: \(cli.unparsedArguments)".red)
    cli.printUsage()
    exit(EX_USAGE)
}

if helpOption.wasSet {
    cli.printUsage()
    exit(EX_OK)
}

if versionOption.wasSet {
    print(appVersion)
    exit(EX_OK)
}

guard classesOption.wasSet || swiftClassOption.wasSet || ocClassOption.wasSet else {
    print("You at least input one class name")
    exit(EX_OK)
}

let projectPath = projectPathOption.value ?? "."
var swiftClasses = swiftClassOption.value ?? []
var ocClasses = ocClassOption.value ?? []
classesOption.value.map {
    swiftClasses.insert(contentsOf: $0, at: 0)
    ocClasses.insert(contentsOf: $0, at: 0)
}
let fileExt = fileExtOption.value ?? ["h", "m", "mm", "swift"]
let printFmt = printFmtOption.value

let findU = FindU(projectPath: projectPath,
                  swiftClasses: swiftClasses,
                  ocClasses: ocClasses,
                  searchInFileExt: fileExt)

let usageInfo = findU.getTotalUsage()

guard let printFmt = printFmt else {
    _ = usageInfo.map { info in
        print("Class: \(info.className) Total: \(info.totalCount) AtFilePathes: [")
        _ = info.atFilePathes.map { print($0) }
        print("]")
    }
    exit(EX_OK)
}

// TODO: print format

