//
//  PostsViewModel.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import Foundation

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
        }
    }
}
