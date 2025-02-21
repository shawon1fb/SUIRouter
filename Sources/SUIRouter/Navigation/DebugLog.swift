//
//  DebugLog.swift
//  SUIRouter
//
//  Created by Shahanul Haque on 2/21/25.
//

import Foundation
import OSLog

class DebugLog: RouteLogger {
    let logger: Logger
    init(logger: Logger) {
        self.logger = logger
    }

    func log(_ value: String) {
        logger.trace("\(value, privacy: .public)")
    }
}
