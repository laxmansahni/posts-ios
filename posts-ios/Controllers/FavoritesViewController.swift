//
//  FavoritesViewController.swift
//  posts-ios
//
//  Created by Laxman on 03/05/23.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    private var favoriteViewModel : FavoritesViewModel!
    
    private var dataSource : PostTableViewDataSource<PostTableViewCell,Post>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.favoriteViewModel =  FavoritesViewModel()
        callToViewModelForUIUpdate()
    }
    
    func callToViewModelForUIUpdate(){
        self.favoriteViewModel.bindFavoriteViewModelToController = {
            self.updateDataSource()
        }
        self.favoriteViewModel.GetFavoriteData()
    }
    
    func updateDataSource(){
        guard let postData = self.favoriteViewModel.favoriteData else { return }
            
        self.dataSource = PostTableViewDataSource(cellIdentifier: "FavoriteTableViewCell", items: postData, configureCell: { (cell, evm) in
            cell.postIdLabel.text = String(evm.id)
            cell.postTitleLabel.text = evm.title
        })
        
        DispatchQueue.main.async {
            self.favoriteTableView.dataSource = self.dataSource
            self.favoriteTableView.reloadData()
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
