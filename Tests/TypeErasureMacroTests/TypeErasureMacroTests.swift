import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(TypeErasureMacroMacros)
import TypeErasureMacroMacros

let testMacros: [String: Macro.Type] = [
    "stringify": TypeErasureMacro.self,
]
#endif

final class TypeErasureMacroTests: XCTestCase {
    func testMacro() throws {
        #if canImport(TypeErasureMacroMacros)
        assertMacroExpansion(
            """
            @TypeErasure
            protocol ContentDrawable {
                var size: CGSize { get }
                var backgroundColor: Color { get }
                
                func draw()
            }
            """,
            expandedSource: """
            @TypeErasure
            protocol ContentDrawable {
                var size: CGSize { get }
                var backgroundColor: Color { get }
                
                func draw()
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
