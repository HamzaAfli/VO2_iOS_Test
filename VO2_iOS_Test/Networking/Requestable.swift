//
//  Requestable.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import Foundation

public protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
}
