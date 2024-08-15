#!/usr/bin/swift

import AppKit
import Foundation

extension String {

    var condensed: String {
        replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
}
 
guard CommandLine.arguments.count == 2 else {
    preconditionFailure("Invalid number of arguments.")
}

let gitBranchName = CommandLine.arguments[1]
    .lowercased()
    .filter {
        $0.isLetter || $0.isWhitespace
    }
    .condensed
    .replacingOccurrences(of: " ", with: "-")

print(gitBranchName)

NSPasteboard.general.clearContents()
NSPasteboard.general.setString(gitBranchName, forType: .string)