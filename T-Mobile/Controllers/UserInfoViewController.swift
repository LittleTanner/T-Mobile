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
        repoTableView.delegate = self
        repoTableView.dataSource = self
        setupUI()
    }
    
    func setupUI() {      
        if let userName = userName {
            NetworkManager.shared.getUserInfo(for: userName) { (user) in
                if let user = user {
                    self.userNameLabel.text = user.userName
                    self.emailLabel.text = user.email ?? "No email"
                    self.locationLabel.text = user.location ?? "No location"
                    self.joinDateLabel.text = user.joinDate
                    self.followersLabel.text = "\(user.followers) Followers"
                    self.followingLabel.text = "Following \(user.following)"
                    self.bioLabel.text = user.bio ?? "No bio"
                    
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
        return NetworkManager.shared.userRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? UserReposTableViewCell else { return UITableViewCell() }
        
        let repo = NetworkManager.shared.userRepos[indexPath.row]
        
        cell.repoNameLabel.text = repo.name
        cell.forksLabel.text = "\(repo.forksCount) Forks"
        cell.starsLabel.text = "\(repo.starCount) Stars"
        
        return cell
    }
    
    
}
