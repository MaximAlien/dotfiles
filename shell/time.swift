#!/usr/bin/swift

import Foundation

print("Current time:")

let runLoop = CFRunLoopGetCurrent()

let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
    fflush(stdout)
    print("\(NSDate.now) \r", terminator: "")
})

CFRunLoopRun()
exit(EXIT_SUCCESS)
