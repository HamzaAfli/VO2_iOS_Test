//
//  UserServiceEndpoints.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

public typealias Headers = [String: String]

enum UserServiceEndpoints {
    
    case getUsersList
    case getUser(userId: String)
    case deleteUser(userId: String)
    case updateUser(user:User)
    
    var requestTimeOut: Int {
        return 20
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getUsersList:
            return .GET
        case .getUser:
            return .GET
        case .deleteUser:
            return .DELETE
        case .updateUser:
            return .PUT
        }
    }
    
    func createRequest(environment: Environment) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"] = "application/json"
        return NetworkRequest(url: getURL(from: environment), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    var requestBody: Encodable? {
        switch self {
        case .updateUser(let user):
            return ["email":user.email,
                    "first_name":user.first_name,
                    "last_name":user.last_name,
                    "avatar":user.avatar]
        default:
            return nil
        }
    }
    func getURL(from environment: Environment) -> String {
        let baseUrl = environment.userServiceBaseUrl
        switch self {
        case .getUsersList:
            return baseUrl + "/api/users"
        case .getUser(userId: let userId):
            return baseUrl + "/api/users/" + userId
        case .deleteUser(userId: let userId):
            return baseUrl + "/api/users/" + userId
        case .updateUser(user: let user):
            return baseUrl + "/api/users/" + "\(user.id)"
        }
    }
}
