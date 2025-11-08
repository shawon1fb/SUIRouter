//
//  UIPilot.swift
//  SUIRouter
//
//  Created by Shahanul Haque on 2/21/25.
//
import Combine
import OSLog
import SwiftUI

// Type-erased base class for navigation observers

// Type-erased base class for navigation observers
open class UIPilotObserverBase<T: Equatable>: Identifiable, Hashable
{

    public let id: String
    public init(id: String) {
        self.id = id
    }
    open func onPush(route: T) {

    }
    open func onPop(route: T) {}
    open func onPopTo(route: T, inclusive: Bool) {}
    open func onRouteChange(oldRoutes: [T], newRoutes: [T]) {}

    // Implementing Hashable protocol methods
    public static func == (
        lhs: UIPilotObserverBase<T>,
        rhs: UIPilotObserverBase<T>
    ) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@MainActor
public class UIPilot<T: Equatable>: ObservableObject {
    // Logger instance used for logging navigation actions
    private let logger: RouteLogger

    // Array to store navigation observers
    private var observers: Set<UIPilotObserverBase<T>> = []

    // Published property to store the navigation paths
    @Published var paths: [UIPilotPath<T>] = [] {
        didSet {
            // Notify observers of route changes
            let oldRoutes = oldValue.map { $0.route }
            let newRoutes = paths.map { $0.route }
            observers.forEach {
                $0.onRouteChange(oldRoutes: oldRoutes, newRoutes: newRoutes)
            }
        }
    }

    // Computed property to return the current stack of routes
    public var stack: [T] {
        return paths.map { $0.route }
    }

    public func getObservers() -> Set<UIPilotObserverBase<T>> {
        return observers
    }

    public init(_ initial: T? = nil, debug: Bool = true) {
        logger =
            debug
            ? DebugLog(logger: Logger(subsystem: "DEBUG", category: " "))
            : EmptyLog()
        logger.log("UIPilot - Pilot Initialized.")

        if let initial = initial {
            push(initial)
        }
    }

    // Method to add a navigation observer
    public func addObserver(_ observer: UIPilotObserverBase<T>) {
        let (inserted, _) = observers.insert(observer)
        if inserted {
            logger.log("UIPilot - Observer added.")

        } else {
            logger.log("UIPilot - Observer already exists.")
        }
    }

    // Method to remove a navigation observer
    public func removeObserver(_ observer: UIPilotObserverBase<T>) {
        if observers.remove(observer) != nil {
            logger.log("UIPilot - Observer removed.")
        } else {
            logger.log("UIPilot - Observer not found.")
        }
    }

    public func push(_ route: T) {
        logger.log("UIPilot - Pushing \(route) route.")
        paths.append(UIPilotPath(route: route))

        // Notify observers
        observers.forEach { $0.onPush(route: route) }
    }

    public func pop() {
        if !paths.isEmpty {
            let poppedRoute = paths.last!.route
            logger.log("UIPilot - Route popped.")
            paths.removeLast()

            // Notify observers
            observers.forEach { $0.onPop(route: poppedRoute) }
        }
    }

    public func popTo(_ route: T, inclusive: Bool = false) {
        logger.log("UIPilot: Popping route \(route).")

        if paths.isEmpty {
            logger.log("UIPilot - Path is empty.")
            return
        }

        guard var found = paths.firstIndex(where: { $0.route == route }) else {
            logger.log("UIPilot - Route not found.")
            return
        }

        if !inclusive {
            found += 1
        }

        let numToPop = (found..<paths.endIndex).count
        logger.log("UIPilot - Popping \(numToPop) routes")

        paths.removeLast(numToPop)

        // Notify observers
        observers.forEach { $0.onPopTo(route: route, inclusive: inclusive) }
    }

    func systemPop(path: UIPilotPath<T>) {
        if paths.count > 1 && path.id == paths[paths.count - 2].id {
            pop()
        }
    }
}
