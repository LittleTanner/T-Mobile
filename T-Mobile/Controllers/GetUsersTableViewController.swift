//
//  GetUsersTableViewController.swift
//  T-Mobile
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class GetUsersTableViewController: UITableViewController {
    
    @IBOutlet weak var getUsersSearchBar: UISearchBar!
    
    //    var user: User?
    
    //    var searchUsers: [SearchUser]? {
    //        didSet {
    //            DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersSearchBar.delegate = self
        //        NetworkManager.shared.getUserInfo(for: "littletanner") { (user) in
        //            self.user = user
        //        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return NetworkManager.shared.searchUsers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        if let username = NetworkManager.shared.searchUsers[indexPath.row].userName{
            cell.userNameLabel.text = username
            
            NetworkManager.shared.getUserInfo(for: username) { (user) in
                if let user = user {
                    DispatchQueue.main.async {
                        cell.numberOfReposLabel.text = "Repos: \(user.numberOfRepos)"
                        //                        self.tableView.reloadData()
                    }
                }
            }
            
            if let searchUsersAvatar = NetworkManager.shared.searchUsers[indexPath.row].avatarURL {
                
                NetworkManager.shared.downloadImage(from: searchUsersAvatar) { (image) in
                    DispatchQueue.main.async {
                        cell.avatarImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToUserDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? UserInfoViewController else { return }
                
                if let userNameToSend = NetworkManager.shared.searchUsers[indexPath.row].userName {
                    destinationVC.userName = userNameToSend
                }
            }
        }
        
        
    }
}

extension GetUsersTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NetworkManager.shared.getUsers(for: searchText) { (searchUsers) in
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//                self.tableView.reloadData()
//            }
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            NetworkManager.shared.getUsers(for: searchText) { (searchUsers) in
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                    self.tableView.reloadData()
                }
            }
        }
    }
}
