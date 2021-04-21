// Name: Nikita Sushko
// ID: 105075196


import Foundation
import CoreData


extension ActivityItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityItem> {
        return NSFetchRequest<ActivityItem>(entityName: "ActivityItem")
    }

    @NSManaged public var activity: String?
    @NSManaged public var createdAt: Date?

}

extension ActivityItem : Identifiable {

}
