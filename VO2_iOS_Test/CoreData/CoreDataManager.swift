//
//  CoreDataManager.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import CoreData
import Foundation

protocol CoreDataManagerProtocol {
 
    func fetchUserList() -> [User]
    func addUser(user: User)
    func deleteUser(userId: Int)
    func updateUser(user: User)
    
}

class CoreDataManager {
    static let shared: CoreDataManagerProtocol = CoreDataManager()
    
    var dbHelper: CoreDataHelper = CoreDataHelper.shared
    
    private init() { }
    
    private func getPersistentUser(for userId: Int) -> PersistentUser? {
        let predicate = NSPredicate(
            format: "id = %@",
            "\(userId)")
        let result = dbHelper.fetchFirst(PersistentUser.self, predicate: predicate)
        switch result {
        case .success(let persistentUser):
            return persistentUser
        case .failure:
            return nil
        }
    }
}

// MARK: - DataManagerProtocol
extension CoreDataManager: CoreDataManagerProtocol {
    func fetchUserList() -> [User] {
        let result: Result<[PersistentUser], Error> = dbHelper.fetch(PersistentUser.self)
        switch result {
        case .success(let persistentUsers):
            return persistentUsers.map { $0.convertToUser() }
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func addUser(user: User) {
        if let _ = getPersistentUser(for: user.id) {
           updateUser(user: user)
        } else if let entity = NSEntityDescription.entity(forEntityName: "PersistentUser", in: dbHelper.context) {
        let newUser = PersistentUser(entity: entity, insertInto: dbHelper.context)
        newUser.id = Int64(user.id)
        newUser.email = user.email
        newUser.first_name = user.first_name
        newUser.last_name = user.last_name
        newUser.avatar = user.avatar
        dbHelper.create(newUser)
        }
    }
    
    func deleteUser(userId: Int) {
        if let entity = getPersistentUser(for: userId) {
        dbHelper.delete(entity)
        }
    }
    
    func updateUser(user: User) {
        if let entity = getPersistentUser(for: user.id) {
            entity.email = user.email
            entity.first_name = user.first_name
            entity.last_name = user.last_name
            entity.avatar = user.avatar
            dbHelper.update(entity)
        }
        
    }
   
}
