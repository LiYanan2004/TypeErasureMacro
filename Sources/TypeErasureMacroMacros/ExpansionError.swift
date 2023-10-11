import Foundation
import SwiftDiagnostics

enum ExpansionError: CustomStringConvertible, Error {
    case unsupported
    
    var description: String {
        switch self {
        case .unsupported: "'@TypeErasure' is only available for custom Protocols"
        }
    }
}

extension ExpansionError: DiagnosticMessage {
    var message: String { description }
    
    var diagnosticID: SwiftDiagnostics.MessageID {
        .init(domain: "com.liyanan2004.macro.TypeErasure", id: "@DIAGNOSE: " + description)
    }
    
    var severity: SwiftDiagnostics.DiagnosticSeverity {
        .error
    }
}

extension ExpansionError: FixItMessage {
    var fixItID: SwiftDiagnostics.MessageID {
        .init(domain: "com.liyanan2004.macro.TypeErasure", id: "@FIXIT: " + description)
    }
}
