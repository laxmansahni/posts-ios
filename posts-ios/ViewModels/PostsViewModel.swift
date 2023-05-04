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
            self.bindPostViewModelToController()
        }
    }
    
    var bindPostViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiService =  APIService()
        callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData() {
        self.apiService.apiToGetPostData { (postData) in
            self.postData = postData
            self.clearData()
            self.saveInCoreDataWith(posts: postData)
        }
    }
    
    private func createPhotoEntityFrom(post: Post) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let postCD = NSEntityDescription.insertNewObject(forEntityName: "PostCD", into: context) as? PostCD {
            postCD.id = post.id
            postCD.title = post.title
            return postCD
        }
        return nil
    }
    
    private func saveInCoreDataWith(posts: [Post]) {
        _ = posts.map{self.createPhotoEntityFrom(post: $0)}
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
}
