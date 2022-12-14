//
//  main.swift
//  
//
//  Created by Jiehao Zhang on 2022/12/14.
//

import Foundation
import CommandLineKit

let appVersion = "0.0.1"

let cli = CommandLineKit.CommandLine()
let projectPathOption = StringOption(
    shortFlag: "p", longFlag: "path", required: false,
    helpMessage: "Root path of your project. Default is current folder.")
cli.addOption(projectPathOption)

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
    helpMessage: "In which type of file you search for usage, defualt is '.m .mm .swift'")
cli.addOption(fileExtOption)

let printFmtOption = StringOption(
    longFlag: "print-format", required: false,
    helpMessage: "Customize the print format. You can pass ClassName:<C> Total:<T>. <C> will be replaced by class name, <T> will be replaced by total count")
cli.addOption(printFmtOption)

let versionOption = BoolOption(
    longFlag: "version",
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

if helpOption.value {
    cli.printUsage()
    exit(EX_OK)
}

if versionOption.value {
    print(appVersion)
    exit(EX_OK)
}


