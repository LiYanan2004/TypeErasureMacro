import SwiftSyntax

extension FunctionDeclSyntax {
    var paramaters: FunctionParameterListSyntax {
        signature.parameterClause.parameters
    }
    
    var returnType: IdentifierTypeSyntax? {
        signature.returnClause?.type.as(IdentifierTypeSyntax.self)
    }
}

extension FunctionParameterSyntax {
    var name: TokenSyntax {
        secondName ?? firstName
    }
}
