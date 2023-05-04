//
//  PostsViewController.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import UIKit

class PostsViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    
    private var postViewModel : PostsViewModel!
    
    private var dataSource : PostTableViewDataSource<PostTableViewCell,Post>!
    let connectionManager = ConnectionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /// Usage of ConnectionManager class
        if connectionManager.isConnected {
            print("Connected")
        } else {
            print("Disconnected")
        }
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        self.postViewModel =  PostsViewModel()
        self.postViewModel.bindPostViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        guard let postData = self.postViewModel.postData else { return }
            
        self.dataSource = PostTableViewDataSource(cellIdentifier: "PostTableViewCell", items: postData, configureCell: { (cell, evm) in
            cell.postIdLabel.text = String(evm.id)
            cell.postTitleLabel.text = evm.title
        })
        
        DispatchQueue.main.async {
            self.postTableView.dataSource = self.dataSource
            self.postTableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
