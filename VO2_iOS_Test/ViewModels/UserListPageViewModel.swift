//
//  UserListPageViewModel.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import Foundation

protocol UserListPageViewModelProtocol {
    var users: [User] { get }
    func deleteUser(userId: Int)
}
enum DeleteUserState {
    case waiting
    case finished
    case failed(NetworkError, userId: Int)
}

final class UserListPageViewModel {
    
    @Published var users = [User]()
    @Published var deleteUserState: DeleteUserState = .waiting
    var subscriptions = Set<AnyCancellable>()

    let service = UserService(networkRequest: NativeRequestable(), environment: .development)
    var dataManager: CoreDataManagerProtocol
    
    init(dataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
    func setUsers(users: [User]) {
        self.users = users
    }
}

// MARK: - UserListPageViewModelProtocol
extension UserListPageViewModel: UserListPageViewModelProtocol {
    func deleteUser(userId: Int) {
        service.deleteUser(userId: "\(userId)").sink { completion in
            switch completion {
            case .failure(let error):
                print("oops got an error \(error.localizedDescription)")
                self.deleteUserState = .failed(error, userId: userId)
            case .finished:
                self.dataManager.deleteUser(userId: userId)
                self.users = self.dataManager.fetchUserList()
                self.deleteUserState = .finished
                
            }
        } receiveValue: { _ in
    
        }.store(in: &subscriptions)

    }
    
}
