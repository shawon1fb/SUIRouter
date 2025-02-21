//
//  UIPilotHost.swift
//  SUIRouter
//
//  Created by Shahanul Haque on 2/21/25.
//

import SwiftUI

public struct UIPilotHost<T: Equatable, Screen: View>: View {
    // An observed object of type UIPilot to manage navigation paths.
    @ObservedObject
    private var pilot: UIPilot<T>

    // A view builder closure that maps routes of type T to views of type Screen.
    @ViewBuilder
    private let routeMap: (T) -> Screen

    // A state property to manage the view generator.
    @State
    private var viewGenerator = ViewGenerator<T, Screen>()

    // Initializer to set up the UIPilotHost with a pilot and a route map.
    public init(_ pilot: UIPilot<T>, @ViewBuilder _ routeMap: @escaping (T) -> Screen) {
        self.pilot = pilot
        self.routeMap = routeMap
        // Set the onPop closure to call the pilot's systemPop method.
        viewGenerator.onPop = { path in
            pilot.systemPop(path: path)
        }
    }

    // The body of the UIPilotHost view.
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, *){
//        if false{
            // Use NavigationStack for iOS 16 and later.
            NavigationStack {
                viewGenerator.build(pilot.paths, routeMap)
            }
            .environmentObject(pilot)
        } else {
            // Use NavigationView for iOS versions earlier than 16.
            NavigationView {
                viewGenerator.build(pilot.paths, routeMap)
            }
            #if !os(macOS)
            .navigationViewStyle(.stack) // Use stack navigation view style on non-macOS platforms.
            #endif
            .environmentObject(pilot)
        }
    }
}

class ViewGenerator<T: Equatable, Screen: View>: ObservableObject {
    // A closure that gets called when a view is popped.
    var onPop: ((UIPilotPath<T>) -> Void)? = nil

    // A dictionary that maps paths to their corresponding views.
    private var pathViews = [UIPilotPath<T>: Screen]()

    // This function builds a hierarchical view structure based on the provided paths and route map.
    @MainActor
    func build(
        _ paths: [UIPilotPath<T>],
        @ViewBuilder _ routeMap: (T) -> Screen
    ) -> PathView<Screen>? {
        // Recycle views that are not in the current paths.
        recycleViews(paths)

        var current: PathView<Screen>?
        // Iterate through the provided paths in reverse order.
        for path in paths.reversed() {
            // Get the existing view for the path or create a new one using the routeMap closure.
            let view = pathViews[path] ?? routeMap(path.route)
            pathViews[path] = view

            // Create a PathView for the current view.
            let content = PathView(view, state: PathViewState())

            // Link the current PathView to the next one.
            content.state.next = current
            content.state.onPop = current == nil ? {} : { [weak self] in
                // Trigger the onPop closure when the top-level view is popped.
                if let self = self {
                    self.onPop?(path)
                }
            }
            current = content
        }
        // Return the top-level view in the hierarchy.
        return current
    }

    // This function recycles views that are no longer needed.
    private func recycleViews(_ paths: [UIPilotPath<T>]) {
        var pathViews = self.pathViews
        // Remove any views whose paths are not in the provided paths.
        for key in pathViews.keys {
            if !paths.contains(key) {
                pathViews.removeValue(forKey: key)
            }
        }
        // Update the pathViews dictionary.
        self.pathViews = pathViews
    }
}
