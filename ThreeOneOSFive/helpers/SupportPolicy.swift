import Foundation

enum ExploitSupportPolicy {
    static let verifiedIOS17Range = "17.0–17.7.x"
    static let verifiedIOS18Range = "18.0–18.7.1"
    static let verifiedIOS26Range = "26.0–26.x"
    static let verifiedIOS27Range = "27.0–27.x"

    /// Builds beta conocidas. Solo se usan para mostrar el número de beta.
    static let verifiedIOS27Betas: [(beta: Int, publicBeta: Int?, build: String)] = [
        (1, nil, "24A5355q"),
        (2, nil, "24A5370h"),
        (3, 1, "24A5380h"),
        (4, 2, "24A5390f"),
        (5, 3, "24A5408d"),
        (6, 4, "24A5418b"),
        (7, 5, "24A5424a")
    ]

    /// Builds finales conocidas, por versión. Solo informativas.
    static let verifiedIOS27ReleaseBuilds: [String: [String]] = [
        "27.0": ["24A435", "24A437"],
        "27.0.1": ["24A446"],
        "27.2": ["24B115", "24B119"]
    ]

    static func iOS27BetaNumber(for build: String) -> Int? {
        verifiedIOS27Betas.first { $0.build == build }?.beta
    }

    static func iOS27PublicBetaNumber(for build: String) -> Int? {
        verifiedIOS27Betas.first { $0.build == build }?.publicBeta
    }

    /// iOS 17 y 18 usan el exploit de kernel opt-in.
    static func supportsKernelExploit(major: Int, minor: Int, patch: Int) -> Bool {
        guard minor >= 0, patch >= 0 else { return false }
        if major == 17 { return minor <= 7 }
        if major == 18 { return minor < 7 || (minor == 7 && patch <= 1) }
        return false
    }

    /// iOS 26 y 27 comparten la misma cadena (kexploit + sandbox_escape).
    /// Se acepta cualquier minor y cualquier patch de esas versiones, y
    /// también cualquier versión posterior. La build ya no bloquea nada:
    /// se intenta y el propio exploit decide.
    static func isSupported(major: Int, minor: Int, patch: Int, build: String) -> Bool {
        if supportsKernelExploit(major: major, minor: minor, patch: patch) { return true }
        return major >= 26
    }

    /// Todo lo que llega a isSupported cuenta como verificado, para que la
    /// interfaz no muestre advertencias en builds no listadas.
    static func isVerifiedBuild(major: Int, minor: Int, patch: Int, build: String) -> Bool {
        if supportsKernelExploit(major: major, minor: minor, patch: patch) { return true }
        return major >= 26
    }
}