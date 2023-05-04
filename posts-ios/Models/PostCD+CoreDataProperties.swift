//
//  PostCD+CoreDataProperties.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import Foundation
import CoreData


extension PostCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostCD> {
        return NSFetchRequest<PostCD>(entityName: "PostCD");
    }

    @NSManaged public var id: Int
    @NSManaged public var title: String
    @NSManaged public var isFavorite: Bool
    

}
