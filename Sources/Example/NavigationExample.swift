//
//  NavigationExample.swift
//  SUIRouter
//
//  Created by Shahanul Haque on 2/21/25.
//

import SwiftUI

// Define routes of the app
private enum AppRoute: Equatable {
    // As swift not able to identify type of closure by default
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        return lhs.key == rhs.key
    }

    case Start
    case Home
    case SignIn
    case Profile(callBack: () -> Void) // Non-escaping Closure

    

    var key: String {
        switch self {
        case .Start:
            return "Start"
        case .Home:
            return "Home"
        case .SignIn:
            return "SignIn"
        case .Profile:
            return "Profile"
  
        }
    }
}


struct StartView: View {
    @EnvironmentObject var pilot: UIPilot<AppRoute>

    var body: some View {
        VStack {
            Button("Let's Start") {
                pilot.push(.Home)
            }
            .padding()
            .background(.cyan)
        }
        .navigationTitle("Start")
    }
}

struct HomeView: View {
    @EnvironmentObject var pilot: UIPilot<AppRoute>

    var body: some View {
        VStack {
            Button("Sign In") {
                pilot.push(.SignIn)
            }
            .padding()
            .background(.green)
        }
        .navigationTitle("Home")
    }
}

struct SignInView: View {
    @EnvironmentObject var pilot: UIPilot<AppRoute>

    var body: some View {
        VStack {
            Button("See your profile") {
                pilot.push(.Profile(callBack: { // Preform callback action
                    self.pilot.popTo(.Start) // Pop from current screen to home route
                }))
            }
            .padding()
            .background(.yellow)

            //            NavigationStack{}
        }
        .navigationTitle("Sign In")
    }
}

struct ProfileView: View {
    @EnvironmentObject var pilot: UIPilot<AppRoute>
    // @Environment(\.uipNavigationStyle) var style: NavigationStyle
    let onSignOut: () -> Void

    init(onSignOut: @escaping () -> Void) {
        self.onSignOut = onSignOut
        // print("ProfileView init")
    }

    var body: some View {
        VStack {
            Button("Sign out") {
                onSignOut() // Call closure
            }
            .padding()
            .background(.red)

            Button("profile again") {
                pilot.push(.Profile(callBack: { // Preform callback action
                    self.pilot.popTo(.Start) // Pop from current screen to home route
                }))
            }
            .padding()
            .background(.green)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

