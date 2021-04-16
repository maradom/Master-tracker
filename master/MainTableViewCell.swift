//
//  MainTableViewCell.swift
//  master
//
//  Created by Martynas Adomaitis on 19/05/2020.
//  Copyright © 2020 Martynas Adomaitis. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet var courseworkNameLabel: UILabel!
    @IBOutlet var moduleNameLabel: UILabel!
    @IBOutlet var courseworkWeightLabel: UILabel!
    @IBOutlet var courseworkLevelLabel: UILabel!
    @IBOutlet var courseworkDueDate: UILabel!
    @IBOutlet var markDisplayLabel: UILabel!
    @IBOutlet var courseworkProgressView: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
