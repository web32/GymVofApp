//
//  PlanCell.swift
//  Gymnasium Vilshofen
//
//  Created by Michael Mayerhofer on 14.10.2014.
//  Copyright (c) 2014 4mayerhofers. All rights reserved.
//

import UIKit

class PlanCell: UITableViewCell {
    
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var lesson: UILabel!
    @IBOutlet weak var of: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var info: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
