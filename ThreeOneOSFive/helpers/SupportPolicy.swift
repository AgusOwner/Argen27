import Foundation

/// Política de compatibilidad verificada.
///
/// Regla: solo se habilitan las builds probadas explícitamente. Las builds de
/// iOS 27 que no estén en `verifiedBuilds` se marcan como no soportadas en vez
/// de asumirse compatibles.
enum ExploitSupportPolicy {

    /// Builds de iOS 27 verificadas por el proyecto.
    static let verifiedBuilds: Set<String> = [
        "24A5355q", // iOS 27 Developer Beta 1
        "24A5370h", // iOS 27 Developer Beta 2
        "24A5380h", // iOS 27 Developer Beta 3 / Public Beta 1
        "24A5390f", // iOS 27 Developer Beta 4 / Public Beta 2
    ]

    /// Tabla legible para la UI y los logs.
    static let verifiedTable: [(version: String, build: String)] = [
        ("27.0 Developer Beta 1", "24A5355q"),
        ("27.0 Developer Beta 2", "24A5370h"),
        ("27.0 Developer Beta 3 / Public Beta 1", "24A5380h"),
        ("27.0 Developer Beta 4 / Public Beta 2", "24A5390f"),
    ]

    static func isVerifiedBuild(_ build: String) -> Bool {
        verifiedBuilds.contains(build.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    /// `true` solo para las versiones y builds verificadas.
    static func isSupported(major: Int, minor: Int, patch: Int, build: String) -> Bool {
        switch major {
        case 17:
            // 17.0 – 17.7 (kernel exploit)
            return minor <= 7
        case 18:
            // 18.0 – 18.7.1 (kernel exploit)
            return minor < 7 || (minor == 7 && patch <= 1)
        case 26:
            // 26.0 – 26.6.1
            return minor < 6 || (minor == 6 && patch <= 1)
        case 27:
            // Solo builds listadas; el resto se marca no soportado.
            return isVerifiedBuild(build)
        default:
            return false
        }
    }

    /// Etiqueta de versión para mostrar al usuario.
    static func displayVersion(major: Int, minor: Int, patch: Int) -> String {
        "\(major).\(minor).\(patch)"
    }

    /// Motivo por el que una build de iOS 27 no está soportada.
    static func unsupportedReason(major: Int, minor: Int, patch: Int, build: String) -> String? {
        let version = displayVersion(major: major, minor: minor, patch: patch)
        guard major == 27, !isVerifiedBuild(build) else { return nil }
        return "iOS \(version) (\(build)) todavía no está verificada."
    }
}

/// Alias por compatibilidad con el nombre corto usado en otras vistas.
typealias SupportPolicy = ExploitSupportPolicy