//
//  Environment.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

public enum Environment: String, CaseIterable {
    case development
    case production
}

extension Environment {
    var userServiceBaseUrl: String {
        switch self {
        case .development:
            return "https://reqres.in"
        case .production:
            return "https://reqres.in"
        }
    }
static func getEnvirement() -> Environment{
#if DEBUG
    return .development
#else
    return .production
#endif
        
    }
}
