//
//  UserEditPageViewModel.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import Foundation

protocol UserEditPageViewModelProtocol {
    func updateUser(user: User)
}
enum UpdateUserState {
    case waiting
    case finished
    case failed(NetworkError, user: User)
}

final class UserEditPageViewModel {
    
    @Published var user: User?
    @Published var updateUserState: UpdateUserState = .waiting
    var subscriptions = Set<AnyCancellable>()

    let service = UserService(networkRequest: NativeRequestable(), environment: .development)
    var dataManager: CoreDataManagerProtocol
    
    init(dataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
    func setUser(user: User) {
        self.user = user
    }
}

// MARK: - UserEditPageViewModelProtocol
extension UserEditPageViewModel: UserEditPageViewModelProtocol {
    func updateUser(user: User) {
        service.updateUser(user: user).sink { completion in
            switch completion {
            case .failure(let error):
                self.updateUserState = .failed(error, user: user)
            case .finished:
                self.dataManager.updateUser(user: user)
                self.updateUserState = .finished
            }
        } receiveValue: { _ in
        }.store(in: &subscriptions)
    }
    
}
