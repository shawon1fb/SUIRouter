//
//  EmptyLog.swift
//  SUIRouter
//
//  Created by Shahanul Haque on 2/21/25.
//

import Foundation
import OSLog

protocol RouteLogger {
    func log(_ value: String)
}

class EmptyLog: RouteLogger {
    func log(_: String) {}
}
