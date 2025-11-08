//
//  PathView.swift
//  SUIRouter
//
//  Created by Shahanul Haque on 2/21/25.
//

import SwiftUI

// PathView is a SwiftUI view that wraps around a content view and manages navigation to the next view.
struct PathView<Screen: View>: View {
    // The content view to be displayed.
    private let content: Screen

    // The state of the PathView, which includes navigation state and next view.
    @ObservedObject var state: PathViewState<Screen>

    // Initializer to set up PathView with content and state.
    public init(_ content: Screen, state: PathViewState<Screen>) {
        self.content = content
        self.state = state
    }

    // The body of the PathView.
    var body: some View {
        VStack {
            if #available(iOS 16.0, macOS 13.0, *) {
                // Use navigationDestination for iOS 16 and later.
                content
                    .navigationDestination(isPresented: $state.isActive) {
                        state.next
                    }
                    // TODO: need a desicion about backbutton
                    .navigationBarBackButtonHidden()
            } else {
                // Use NavigationLink for iOS versions earlier than 16.
                NavigationLink(
                    destination: self.state.next,
                    isActive: self.$state.isActive
                ) {
                    EmptyView()
                }
                #if os(iOS)
                    // Disable detail link on iOS to avoid unwanted behaviour.
                    .isDetailLink(false)
                #endif
                content
            }
        }
    }
}

// PathViewState is an observable object that manages the state of PathView, including the active state and the next view.
class PathViewState<Screen: View>: ObservableObject {
    // Indicates whether the view is active.
    @Published
    var isActive: Bool = false {
        didSet {
            // Trigger onPop closure when the view becomes inactive and there is a next view.
            if !isActive && next != nil {
                onPop()
            }
        }
    }

    // The next view in the navigation stack.
    @Published
    var next: PathView<Screen>? {
        didSet {
            // Set isActive to true if there is a next view.
            isActive = next != nil
        }
    }

    // A closure that gets called when the view is popped.
    var onPop: () -> Void

    // Initializer to set up PathViewState with an optional next view and onPop closure.
    init(next: PathView<Screen>? = nil, onPop: @escaping () -> Void = {}) {
        self.next = next
        self.onPop = onPop
    }
}
