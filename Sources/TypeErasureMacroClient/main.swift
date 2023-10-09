import TypeErasureMacro
import SwiftUI

@TypeErasure
protocol ContentDrawable {
    var size: CGSize { get }
    var backgroundColor: Color { get }
    
    func draw()
}

//struct AnyContentDrawable: ContentDrawable {
//    private var _size: CGSize
//    private var _backgroundColor: Color
//    private var _draw: () -> Void
//    
//    init(contentdrawable: ContentDrawable) {
//        _size = contentdrawable.size
//        _backgroundColor = contentdrawable.backgroundColor
//        _draw = contentdrawable.draw
//    }
//    
//    var size: CGSize { _size }
//    var backgroundColor: Color { _backgroundColor }
//    func draw() {
//        _draw()
//    }
//}
