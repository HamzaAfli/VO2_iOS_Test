//
//  CoreDataHelper.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import CoreData
import Foundation

class CoreDataHelper: DBHelperProtocol {
    static let shared = CoreDataHelper()
    
    typealias ObjectType = NSManagedObject
    typealias PredicateType = NSPredicate
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: - DBHelper Protocol
    
    func create(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("error saving context while creating an object")
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error> {
        let request = NSFetchRequest<T>(entityName: T.description())
        request.predicate = predicate
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSort]
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        do {
            let result = try context.fetch(request)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
//        let result = fetch(objectType, predicate: predicate, limit: 1)
//        switch result {
//        case .success(let todos):
//            return .success(todos.first as? T)
//        case .failure(let error):
//            return .failure(error)
//        }
        let request = NSFetchRequest<T>(entityName: T.description())
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request)
            return .success(result.first)
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ object: NSManagedObject) {
        do {
            try context.save()
        } catch {
            fatalError("error saving context while updating an object")
        }
    }
    
    func delete(_ object: NSManagedObject) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        context.delete(object)
        saveContext()
    }
    
    // MARK: - Core Data
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "VO2_iOS_Test")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
