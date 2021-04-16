//
//  TaskTableViewCell.swift
//  master
//
//  Created by Martynas Adomaitis on 20/05/2020.
//  Copyright © 2020 Martynas Adomaitis. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet var taskNameLabel: UILabel!
    @IBOutlet var taskTimeLeft: UILabel!
    @IBOutlet var taskProgressLabel: UILabel!
    @IBOutlet var taskProgresBar: UIProgressView!
    @IBOutlet var taskStartLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
