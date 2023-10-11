import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct TypeErasureMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let protDecl = declaration.as(ProtocolDeclSyntax.self)
        else {
            let error = ExpansionError.unsupported
            let fixit = FixIt.replace(
                message: error,
                oldNode: node,
                newNode: DeclSyntax(stringLiteral: "")
            )
            let diagnostic = Diagnostic(node: node, message: error, fixIt: fixit)
            context.diagnose(diagnostic)
            return []
        }
        
        let protocolName = protDecl.name
        let members = protDecl.memberBlock.members
        let memberDeclarations = members.compactMap { $0.as(MemberBlockItemSyntax.self)?.decl }
        let comformanceDeclarations = memberDeclarations.flatMap { decl -> [String] in
            if let funcDecl = decl.as(FunctionDeclSyntax.self) {
                let parameters = funcDecl.paramaters
                let inputTypes = parameters
                    .map { "_ \($0.name.text): \($0.type.description)" }
                    .joined(separator: ", ")
                let inputParameters = parameters
                    .map { $0.name.text }
                    .joined(separator: ", ")
                let returnType = funcDecl.returnType?.name ?? "Void"

                return [
                    "private var _\(funcDecl.name): (\(inputTypes)) -> \(returnType)",
                    "\(funcDecl.trimmed) { _\(funcDecl.name)(\(inputParameters)) }"
                ]
            } else if let varDecl = decl.as(VariableDeclSyntax.self) {
                var declarations: [String] = []
                for (name, type) in zip(varDecl.names, varDecl.types) {
                    declarations.append("private var _\(name): \(type)")
                    declarations.append("var \(name): \(type) { _\(name) }")
                }
                return declarations
            }
            return []
        }
        let initializerBodyDeclarations = memberDeclarations
            .flatMap { decl -> [String] in
                if let functionDecl = decl.as(FunctionDeclSyntax.self) {
                    return ["_\(functionDecl.name) = \(protocolName.text.lowercased()).\(functionDecl.name)"]
                } else if let variableDecl = decl.as(VariableDeclSyntax.self) {
                    var declarations: [String] = []
                    for name in variableDecl.names {
                        declarations.append(
                            "_\(name) = \(protocolName.text.lowercased()).\(name)"
                        )
                    }
                    return declarations
                }
                return []
            }
        
        let structDecl = try StructDeclSyntax("struct Any\(protocolName): \(protocolName)") {
            for comformanceDeclaration in comformanceDeclarations {
                DeclSyntax(stringLiteral: comformanceDeclaration)
            }
            try InitializerDeclSyntax("init(_ \(raw: protocolName.text.lowercased()): \(protocolName))") {
                for initializerBodyDeclaration in initializerBodyDeclarations {
                    ExprSyntax(stringLiteral: initializerBodyDeclaration)
                }
            }
        }
        
        return [DeclSyntax(structDecl)]
    }
}

