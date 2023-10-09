import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct TypeErasureMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TypeErasureMacro.self,
    ]
}
