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
        self.postViewModel =  PostsViewModel()
        /// Usage of ConnectionManager class
        if connectionManager.isConnected {
            self.postViewModel.isConnected = true
        } else {
            self.postViewModel.isConnected = false
        }
        callToViewModelForUIUpdate()
        self.postTableView.delegate = self
    }
    
    func callToViewModelForUIUpdate(){
        self.postViewModel.bindPostViewModelToController = {
            self.updateDataSource()
        }
        self.postViewModel.GetPostData()
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

extension PostsViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let post = self.postViewModel.postData[indexPath.row]
       self.postViewModel.updateInCoreDataWith(post: post)
  }
}
