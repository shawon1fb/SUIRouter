# SUIRouter

SUIRouter is a SwiftUI navigation library inspired by [UIPilot](https://github.com/canopas/UIPilot), optimized and redesigned specifically for SwiftUI applications. It provides a clean, type-safe navigation system that works seamlessly with SwiftUI's navigation architecture.

## Features

- 🎯 SwiftUI-native navigation
- 🔄 Type-safe routing with enum-based routes
- 📱 iOS 15+ and macOS 11+ optimized
- 🎨 Clean SwiftUI integration
- 🔋 Support for NavigationStack (iOS 16+) and NavigationView
- 📊 Navigation state observation system
- ↩️ Custom back navigation handling
- 🔄 Closure-based route callbacks

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

Create an enum for your app's navigation routes:

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

### 2. Set Up Your Navigation Structure

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

### 3. Implement Your Views

Example of a view with navigation:

```swift
struct HomeView: View {
    @EnvironmentObject var pilot: UIPilot<AppRoute>
    
    var body: some View {
        VStack {
            Button("Sign In") {
                pilot.push(.signIn)
            }
            .padding()
            .background(.green)
        }
        .navigationTitle("Home")
    }
}
```

### 4. Navigation with Callbacks

Example using callback routes:

```swift
struct SignInView: View {
    @EnvironmentObject var pilot: UIPilot<AppRoute>
    
    var body: some View {
        Button("See Profile") {
            pilot.push(.profile(callback: {
                // Handle sign out
                self.pilot.popTo(.start)
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
// Keep target route
pilot.popTo(.home, inclusive: false)

// Remove target route too
pilot.popTo(.home, inclusive: true)
```

## iOS Version Compatibility

SUIRouter automatically handles navigation differences between iOS versions:

- iOS 16+: Uses `NavigationStack`
- iOS 15 and earlier: Uses `NavigationView`

This is handled internally by the library, providing a consistent API regardless of iOS version.

## Observer Pattern

Monitor navigation changes:

```swift
class NavigationObserver: UIPilotObserverBase<AppRoute> {
    override func onPush(route: AppRoute) {
        print("Pushed: \(route)")
    }
    
    override func onPop(route: AppRoute) {
        print("Popped: \(route)")
    }
    
    override func onRouteChange(oldRoutes: [AppRoute], newRoutes: [AppRoute]) {
        print("Route stack changed")
    }
}

// Usage
let observer = NavigationObserver(id: "main")
pilot.addObserver(observer)
```

## Requirements

- iOS 15.0+
- macOS 11.0+
- watchOS 6.0+
- tvOS 13.0+
- Swift 5.5+

## Best Practices

1. **Route Organization**
   - Keep route cases logically grouped
   - Use meaningful route names
   - Document complex route parameters

2. **View Structure**
   - Use separate files for each view
   - Keep navigation logic in parent views
   - Leverage SwiftUI's view modifiers

3. **Navigation State**
   - Use `@EnvironmentObject` for pilot access
   - Handle navigation callbacks appropriately
   - Consider deep linking scenarios

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Credits

This library is inspired by [UIPilot](https://github.com/canopas/UIPilot) and has been adapted specifically for SwiftUI with additional features and optimizations.

## License

SUIRouter is available under the MIT license. See the LICENSE file for more info.

## Author

Created by Shahanul Haque

## Support

If you encounter any issues or need help:
1. Check the documentation
2. Open an issue on GitHub
3. Contact the maintainers
