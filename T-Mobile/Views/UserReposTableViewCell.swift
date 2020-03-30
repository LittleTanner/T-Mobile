//
//  UserReposTableViewCell.swift
//  T-Mobile
//
//  Created by Kevin Tanner on 3/30/20.
//  Copyright © 2020 Kevin Tanner. All rights reserved.
//

import UIKit

class UserReposTableViewCell: UITableViewCell {

    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
