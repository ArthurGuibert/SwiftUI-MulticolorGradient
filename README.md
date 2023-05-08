# SwiftUI-MulticolorGradient
A SwiftUI implementation of multiple color gradient 🌈

## Usage
You can use it as a regular SwiftUI view
 ```swift
MulticolorGradient {
    ColorStop(position: .top, color: .red)
    ColorStop(position: .bottomLeading, color: .blue)
    ColorStop(position: .topTrailing, color: .green)
}
```
   
You can add up to 8 color stops (or points). Animations have a basic support: only linear animations are supported for now. 

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/ArthurGuibert/SwiftUI-MulticolorGradient.git")
]
```

## Requirements

* iOS 15.0+
* Xcode 14+
