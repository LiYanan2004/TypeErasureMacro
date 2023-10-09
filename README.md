# TypeErasureMacro

A simple & quick way to create a type eraser for your custom Protocols.

# Supported Platforms

* macOS 10.15+
* iOS 13.0+
* watchOS 6.0+
* tvOS 13.0+
* macCatalyst 13.0+

# Getting started

### Custom Protocol with `@TypeErasure`

```swift
@TypeErasure
protocol ContentDrawable {
    var size: CGSize { get }
    var backgroundColor: Color { get }
    
    func draw()
}
```

### Expanded Code

```swift
protocol ContentDrawable {
    var size: CGSize { get }
    var backgroundColor: Color { get }
    
    func draw()
}

struct AnyContentDrawable : ContentDrawable  {
    private var _size: CGSize
    var size: CGSize  {
        _size
    }
    private var _backgroundColor: Color
    var backgroundColor: Color  {
        _backgroundColor
    }
    private var _draw: () -> Void
    func draw() {
        _draw()
    }
    init(_ contentdrawable: ContentDrawable ) {
        _size = contentdrawable.size
        _backgroundColor = contentdrawable.backgroundColor
        _draw = contentdrawable.draw
    }
}
```

