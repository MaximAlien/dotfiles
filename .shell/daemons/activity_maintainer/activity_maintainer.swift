#!/usr/bin/swift

import Foundation
import Cocoa
import Darwin

final class StandardErrorStream: TextOutputStream {
    
    func write(_ string: String) {
        FileHandle.standardError.write(Data(string.utf8))
    }
}

final class StandardOutputStream: TextOutputStream {
    
    func write(_ string: String) {
        FileHandle.standardOutput.write(Data(string.utf8))
    }
}

var errorStream = StandardErrorStream()
var outputStream = StandardOutputStream()

struct InactivityTracker {
    
    private var timeoutInterval: TimeInterval = 1.0
    private var timer: Timer?
    private var eventTypes: [CGEventType] = []
    
    enum InactivityTrackerError: Error {
        case invalidArguments
    }
    
    mutating func start(_ eventTypes: [CGEventType], handler: @escaping (_ inactivityDetails: Dictionary<CGEventType, TimeInterval>?, _ error: InactivityTrackerError?) -> Void) {
        if let _ = timer {
            print("Timer is already initialized.\n", to: &errorStream)
            handler(nil, .invalidArguments)
            return
        }
        
        if eventTypes.isEmpty {
            print("Event types should contain at least 1 item.", to: &errorStream)
            handler(nil, .invalidArguments)
            return
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeoutInterval, repeats: true, block: { timer in
            var inactivityDetails: Dictionary<CGEventType, TimeInterval> = [:]
            for eventType in eventTypes {
                let lastEventTimeInterval: CFTimeInterval = CGEventSource.secondsSinceLastEventType(CGEventSourceStateID.hidSystemState, eventType: eventType)
                inactivityDetails[eventType] = lastEventTimeInterval
            }
            
            handler(inactivityDetails, nil)
        })
    }
    
    mutating func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

final class ActivityMaintainer {
    
    private var inactivityTracker = InactivityTracker()
    private var lastActivityDate: Date? = nil
    
    public var inactivityInterval: TimeInterval = 60.0
    public var mouseLocationRange: Range<Int> = -50..<50
    
    func start() {
        let eventTypes = [CGEventType.mouseMoved, CGEventType.leftMouseDown]
        self.inactivityTracker.start(eventTypes) { [weak self] (inactivityDetails, error) in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Error occured: \(error).", to: &outputStream)
            }
            
            guard let inactivityDetails = inactivityDetails else {
                return
            }
            
            var inactivityIntervalsCounter = 0
            for (_, eventInactivityTime) in inactivityDetails {
                if eventInactivityTime > self.inactivityInterval {
                    inactivityIntervalsCounter += 1
                }
            }
            
            if inactivityIntervalsCounter == inactivityDetails.keys.count {
                let mouseLocation = NSEvent.mouseLocation
                let x = mouseLocation.x + CGFloat(Int.random(in: self.mouseLocationRange))
                let y = mouseLocation.y + CGFloat(Int.random(in: self.mouseLocationRange))
                let newLocation = CGPoint(x: x, y: y)
                
                CGDisplayMoveCursorToPoint(0, newLocation)
                
                if self.lastActivityDate == nil {
                    self.lastActivityDate = Date()
                    
                    print("Since \(self.lastActivityDate!) user is inactive.", to: &outputStream)
                }
            } else {
                if let date = self.lastActivityDate {
                    let inactivityTime = Date().timeIntervalSince(date)
                    print("Since \(Date()) user is active. User was inactive for: \(String(format: "%.2f", inactivityTime)) seconds.\n", to: &outputStream)
                }
                
                self.lastActivityDate = nil
            }
        }
    }
}

let runLoop = CFRunLoopGetCurrent()

let activityMaintainer = ActivityMaintainer()
activityMaintainer.inactivityInterval = 120.0
activityMaintainer.mouseLocationRange = -100..<100
activityMaintainer.start()

CFRunLoopRun()
exit(EXIT_SUCCESS)
