//
//  PostsViewModel.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import Foundation
import CoreData

class PostsViewModel : NSObject {
    
    private var apiService : APIService!
    private(set) var postData : [Post]! {
        didSet {
            self.bindPostViewModelToController?()
        }
    }
    
    var bindPostViewModelToController : (() -> ())?
    
    public var isConnected: Bool = false
    
    override init() {
        super.init()
        self.apiService =  APIService()
    }
    
    func GetPostData() {
        if isConnected {
            self.apiService.apiToGetPostData { (postData) in
                self.postData = postData
                self.clearData()
                self.saveInCoreDataWith(posts: postData)
            }
        } else {
            self.fetchDataFromCoreData { (postData) in
                self.postData = postData
            }
        }
    }
    
    private func createPostEntityFrom(post: Post) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let postCD = NSEntityDescription.insertNewObject(forEntityName: "PostCD", into: context) as? PostCD {
            postCD.id = post.id
            postCD.title = post.title
            return postCD
        }
        return nil
    }
    
    private func saveInCoreDataWith(posts: [Post]) {
        _ = posts.map{self.createPostEntityFrom(post: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: PostCD.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    private func fetchDataFromCoreData(completion : @escaping (Posts) -> ()){
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: PostCD.self))
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
    
    func updateInCoreDataWith(post: Post) {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: PostCD.self))
        fetchRequest.predicate = NSPredicate(format: "id = %d", post.id)
        
        do {
            let objects = try context.fetch(fetchRequest)
            let objectUpdate = objects[0] as! PostCD
            objectUpdate.setValue(true, forKey: "isFavorite")
            do {
                try context.save()
            }
            catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}
