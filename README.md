# SwiftUI-MulticolorGradient
A SwiftUI implementation of multiple color gradient 🌈

<img src="https://user-images.githubusercontent.com/6124571/236790059-f93b820f-512e-4989-9529-bfbeff821cc4.PNG" width="180" /> <img src="https://user-images.githubusercontent.com/6124571/236790100-a88fe30e-9143-4ee6-b8ee-0e3462551ae6.gif" width="180" />

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
