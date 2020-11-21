#!/usr/bin/swift

import Foundation

func execute(_ command: String, args: [String]) -> String? {
    let process = Process()
    process.launchPath = command
    process.arguments = args
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)
    
    return output
}

print("Current date:")

let runLoop = CFRunLoopGetCurrent()

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "HH:mm:ss yyyy-MM-dd"

let cityToTimeZoneDictionary = [
    "Lviv": "UTC+3",
    "Amsterdam": "UTC+2",
    "New York City": "UTC-4",
    "San Francisco": "UTC-7"
]

let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
    // fflush(stdout)
    
    let currentDate = NSDate.now
    var fullDateString: String = ""
    for (city, timeZone) in cityToTimeZoneDictionary {
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        fullDateString += "\(city): \(dateFormatter.string(from: currentDate))\n"
    }

    print("\(fullDateString)", terminator: "")
    
    if let output = execute("~/Desktop/a.out", args: ["5"]) {
        print("\(output)")
    }
})

CFRunLoopRun()
exit(EXIT_SUCCESS)
