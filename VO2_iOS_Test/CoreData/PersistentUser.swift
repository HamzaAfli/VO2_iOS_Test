//
//  PersistentUser.swift
//  VO2_iOS_Test
//
//  Created by Hamza Afli on 6/12/2021.
//

import CoreData

@objc(PersistentUser)
final class PersistentUser: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistentUser> {
        NSFetchRequest<PersistentUser>(entityName: "PersistentUser")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var email: String?
    @NSManaged public var first_name: String?
    @NSManaged public var id: Int64
    @NSManaged public var last_name: String?

}
extension PersistentUser {
    func convertToUser() -> User {
        User(id: Int(id), email: email ?? "", first_name: first_name ?? "", last_name: last_name ?? "", avatar: avatar ?? "")
    }
}
