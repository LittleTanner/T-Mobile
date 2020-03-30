//
//  UserInfoViewController.swift
//  T-Mobile
//
//  Created by Kevin Tanner on 3/27/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var repoSearchBar: UISearchBar!
    @IBOutlet weak var repoTableView: UITableView!
    
    var isFiltering: Bool = false
    var filteredUserRepos: [UserRepo] = []
    var userName: String? {
        didSet {
            setupUI()
        }
    }
    
    
    var userRepos: [UserRepo]? {
        didSet {
            DispatchQueue.main.async {
                self.repoTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repoSearchBar.delegate = self
        repoTableView.delegate = self
        repoTableView.dataSource = self
    }
    
    func setupUI() {      
        if let userName = userName {
            NetworkManager.shared.getUserInfo(for: userName) { (user) in
                if let user = user {
                    DispatchQueue.main.async {
                        self.userNameLabel.text = user.userName
                        self.emailLabel.text = user.email ?? "No email"
                        self.locationLabel.text = user.location ?? "No location"
                        self.joinDateLabel.text = user.joinDate
                        self.followersLabel.text = "\(user.followers) Followers"
                        self.followingLabel.text = "Following \(user.following)"
                        self.bioLabel.text = user.bio ?? "No bio"

                    }
                    
                    NetworkManager.shared.getUserRepos(for: user.userName) { (userRepos) in
                        print("Get user repos ran")
                        self.userRepos = userRepos
                    }
                    
                    NetworkManager.shared.downloadImage(from: user.avatarURL) { (image) in
                        DispatchQueue.main.async {
                            self.avatarImageView.image = image
                        }
                    }
                }
            }
        }
    }
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering == true {
            return filteredUserRepos.count
        } else {
            return NetworkManager.shared.userRepos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? UserReposTableViewCell else { return UITableViewCell() }
        
        if isFiltering == true {
            let repo = filteredUserRepos[indexPath.row]
            cell.repoNameLabel.text = repo.name
            cell.forksLabel.text = "\(repo.forksCount) Forks"
            cell.starsLabel.text = "\(repo.starCount) Stars"
        } else {
            let repo = NetworkManager.shared.userRepos[indexPath.row]
            cell.repoNameLabel.text = repo.name
            cell.forksLabel.text = "\(repo.forksCount) Forks"
            cell.starsLabel.text = "\(repo.starCount) Stars"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFiltering == true {
            let selectedRepo = filteredUserRepos[indexPath.row]
            if let url = URL(string: selectedRepo.url) {
                UIApplication.shared.open(url)
            }
            
        } else {
            let selectedRepo = NetworkManager.shared.userRepos[indexPath.row]
            if let url = URL(string: selectedRepo.url) {
                UIApplication.shared.open(url)
            }
        }
    }
}


extension UserInfoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isFiltering = false
            self.repoTableView.reloadData()
        }
        
        if let userRepos = userRepos {
            isFiltering = true
            filteredUserRepos = []
            for repo in userRepos {
                if repo.name.lowercased().contains(searchText.lowercased()) {
                    filteredUserRepos.append(repo)
                }
            }


            self.repoTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let userRepos = userRepos {
            isFiltering = true
            filteredUserRepos = []
            guard let searchText = searchBar.text, searchText != "" else {
                isFiltering = false
                self.repoTableView.reloadData()
                searchBar.resignFirstResponder()
                return
            }
            
            for repo in userRepos {
                if repo.name.lowercased().contains(searchText.lowercased()) {
                    filteredUserRepos.append(repo)
                }
            }

            self.repoTableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}
