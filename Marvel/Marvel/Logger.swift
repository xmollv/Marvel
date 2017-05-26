//
//  Logger.swift
//  Marvel
//
//  Created by Xavi Moll on 26/05/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

final class Logger {
    
    enum LogEvent: String {
        case debug = "[💬]"
        case warning = "[⚠️]"
        case error = "[‼️]"
    }
    
    class func log(message: String, event: LogEvent, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
            print("\(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(funcName) -> \(message)")
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.last ?? ""
    }
}
