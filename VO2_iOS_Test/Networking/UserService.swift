//
//  UserService.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import Foundation

protocol UserServiceable {
    
    func getUsersList() -> AnyPublisher<DataResponse, NetworkError>
    func getUser(userId: String) -> AnyPublisher<DataResponse, NetworkError>
    func deleteUser(userId: String) -> AnyPublisher<NoReply, NetworkError>
    func updateUser(user:User)  -> AnyPublisher<UpdateUser, NetworkError>
    
}

class UserService: UserServiceable {
    static let shared: UserService = UserService(networkRequest: NativeRequestable(), environment: Environment.getEnvirement())
    
    func getUser(userId: String) -> AnyPublisher<DataResponse, NetworkError> {
        let endpoint = UserServiceEndpoints.getUser(userId: userId)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    func deleteUser(userId: String) -> AnyPublisher<NoReply, NetworkError> {
        let endpoint = UserServiceEndpoints.deleteUser(userId: userId)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    func updateUser(user: User) -> AnyPublisher<UpdateUser, NetworkError> {
        let endpoint = UserServiceEndpoints.updateUser(user: user)
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    func getUsersList() -> AnyPublisher<DataResponse, NetworkError> {
        let endpoint = UserServiceEndpoints.getUsersList
        let request = endpoint.createRequest(environment: self.environment)
        return self.networkRequest.request(request)
    }
    
    
    private var networkRequest: Requestable
    private var environment: Environment = .development
    
    // inject this for testability
    init(networkRequest: Requestable, environment: Environment) {
        self.networkRequest = networkRequest
        self.environment = environment
    }
    
    
    
}



public struct DataResponse: Codable {
    public let page: Int
    public let users: [User]
    public let support: SupportResponse
    public let per_page:Int
    public let total:Int
    public let total_pages:Int
    
    enum CodingKeys: String, CodingKey {
        case page,support,per_page,total,total_pages
        case users = "data"
    }
}
public struct SupportResponse: Codable {
    public let url: String
    public let text: String
    
}
public struct UpdateUser: Codable {
    public let updatedAt: String
}
public struct NoReply: Codable {
    
}



