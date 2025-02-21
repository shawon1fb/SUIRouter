
# SUIRouter

SUIRouter is a powerful and flexible navigation library for SwiftUI applications that provides programmatic navigation control with a clean, declarative API. It supports iOS 15+, macOS 11+, watchOS 6+, and tvOS 13+.

## Features

- 🎯 Type-safe routing
- 🔄 Programmatic navigation control
- 🏗️ Built for SwiftUI
- 📱 Deep linking support
- 🎨 Clean and declarative API
- 🔋 iOS 15+ and macOS 11+ support
- 📊 Navigation state observation
- ↩️ Custom back button handling

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/shawon1fb/SUIRouter.git", from: "1.0.0")
]
```

Or in Xcode:
1. Go to File > Add Packages
2. Paste the repository URL: `https://github.com/shawon1fb/SUIRouter.git`
3. Click "Add Package"

## Quick Start

### 1. Define Your Routes

First, define an enum that represents all possible routes in your application:

```swift
enum AppRoute: Equatable {
    case start
    case home
    case signIn
    case profile(callback: () -> Void)
    
    // Required for routes with closures
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        return lhs.key == rhs.key
    }
    
    var key: String {
        switch self {
        case .start: return "Start"
        case .home: return "Home"
        case .signIn: return "SignIn"
        case .profile: return "Profile"
        }
    }
}
```

### 2. Initialize UIPilot

Create a UIPilot instance with your routes:

```swift
let pilot = UIPilot<AppRoute>(debug: true)
```

### 3. Set Up Navigation Host

Wrap your initial view with `UIPilotHost` and provide route mapping:

```swift
struct ContentView: View {
    @StateObject private var pilot = UIPilot<AppRoute>(.start)
    
    var body: some View {
        UIPilotHost(pilot) { route in
            switch route {
            case .start:
                StartView()
            case .home:
                HomeView()
            case .signIn:
                SignInView()
            case .profile(let callback):
                ProfileView(onSignOut: callback)
            }
        }
    }
}
```

### 4. Navigate Between Screens

Use the pilot object to navigate between screens:

```swift
struct HomeView: View {
    @EnvironmentObject var pilot: UIPilot<AppRoute>
    
    var body: some View {
        Button("Go to Profile") {
            pilot.push(.profile(callback: {
                // Handle sign out
                pilot.popTo(.start)
            }))
        }
    }
}
```

## Navigation APIs

### Push a New Route

```swift
pilot.push(.home)
```

### Pop Current Route

```swift
pilot.pop()
```

### Pop to Specific Route

```swift
// Pop to route, keeping the target route
pilot.popTo(.home, inclusive: false)

// Pop to route, removing the target route as well
pilot.popTo(.home, inclusive: true)
```

## Advanced Features

### Navigation Observers

You can observe navigation changes by creating a custom observer:

```swift
class NavigationObserver: UIPilotObserverBase<AppRoute> {
    override func onPush(route: AppRoute) {
        print("Pushed to: \(route)")
    }
    
    override func onPop(route: AppRoute) {
        print("Popped from: \(route)")
    }
}

// Add observer
let observer = NavigationObserver(id: "main")
pilot.addObserver(observer)
```

### Custom Back Button Handling

```swift
struct CustomView: View {
    var body: some View {
        Text("Custom View")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CustomBackButton()
                }
            }
    }
}
```

## Best Practices

1. **Route Definition**: Keep your route enum clean and organized. Group related routes together.

2. **State Management**: Use the pilot object for navigation-related state management only.

3. **View Organization**: Create separate view files for each route to maintain code organization.

4. **Type Safety**: Leverage Swift's type system by passing necessary data through route cases.

## Example Project

Check out the complete example project in the repository for more detailed implementation patterns and best practices.

## Requirements

- iOS 15.0+
- macOS 11.0+
- watchOS 6.0+
- tvOS 13.0+
- Swift 5.5+

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

SUIRouter is available under the MIT license. See the LICENSE file for more info.

## Support

If you have any questions or need help, please:
1. Check the documentation
2. Open an issue on GitHub
3. Contact the maintainers

## Author

Created by Shahanul Haque
