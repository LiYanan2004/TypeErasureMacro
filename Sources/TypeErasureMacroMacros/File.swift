import SwiftSyntax

extension VariableDeclSyntax {
    var names: [TokenSyntax] {
        bindings.map {
            $0.pattern
                .as(IdentifierPatternSyntax.self)?
                .identifier ?? "_"
        }
    }
    
    var types: [TypeSyntax] {
        bindings.map {
            $0.typeAnnotation?
                .type ?? "_"
        }
    }
}
