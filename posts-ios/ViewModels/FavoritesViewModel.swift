//
//  PostsViewModel.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import Foundation
import CoreData

class FavoritesViewModel : NSObject {
    
    private(set) var favoriteData : [Post]! {
        didSet {
            self.bindFavoriteViewModelToController?()
        }
    }
    
    var bindFavoriteViewModelToController : (() -> ())?
    
    override init() {
        super.init()
    }
    
    func GetFavoriteData() {
        
        self.fetchFavoritesFromCoreData { (postData) in
            self.favoriteData = postData
        }
    }
    
    private func fetchFavoritesFromCoreData(completion : @escaping (Posts) -> ()){
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: PostCD.self))
            fetchRequest.predicate = NSPredicate(format: "isFavorite = %d", true)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            var posts = [Post]()
            do {
                let objects  = try context.fetch(fetchRequest) as? [PostCD]
                for object in objects ?? [] {
                    let post = Post(userID: 0, id: object.id, title: object.title, body: "")
                    posts.append(post)
                }
            } catch let error {
                print("ERROR FETCHING : \(error)")
            }
            completion(posts)
        }
    }
}
