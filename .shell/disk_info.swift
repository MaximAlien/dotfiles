#!/usr/bin/swift

import Foundation

func freeSize() -> Result<Int64, Error> {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    do {
        let attributes = try FileManager.default.attributesOfFileSystem(forPath: paths.last!)
        // systemSize - 
        let systemFreeSize = attributes[FileAttributeKey.systemFreeSize] as? Int64
        return Result.success(systemFreeSize!)
    } catch {
        return Result.failure(error)
    }
}

let result = freeSize()

switch result {
case .success(let systemFreeSize):
    let size = systemFreeSize / (1024 * 1024 * 1024) // GB
    print("Free system size: \(size) GB.")
case .failure(_):
    print("Failed to getsystem free size.")
}
