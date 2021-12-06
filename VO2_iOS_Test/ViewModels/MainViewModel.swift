//
//  MainViewModel.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import Combine
import Foundation

protocol MainViewModelProtocol {
    var users: [User] { get }
    func fetchUsers()
}
enum FetchUserState {
    case waiting
    case finished
    case failed(NetworkError)
}

final class MainViewModel {
    
    @Published var users = [User]()
    @Published var  fetchUserState: FetchUserState = .waiting
    var subscriptions = Set<AnyCancellable>()

    let service = UserService(networkRequest: NativeRequestable(), environment: .development)

    var dataManager: CoreDataManagerProtocol
    
    init(dataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.dataManager = dataManager
    }
}

// MARK: - MainViewModelProtocol
extension MainViewModel: MainViewModelProtocol {
    func fetchUsers() {
         service.getUsersList().sink { completion in
            switch completion {
            case .failure(let error):
                print("oops got an error \(error.localizedDescription)")
                self.fetchUserState = .failed(error)
            case .finished:
                self.users = self.dataManager.fetchUserList()
                self.fetchUserState = .finished
               
            }
        } receiveValue: { response in
            print("got my response here:")
            response.users.forEach { user in
                self.dataManager.addUser(user: user)
                print(user.email, user.last_name, user.id)
            }
         }
        .store(in: &subscriptions)
    }
    
}
