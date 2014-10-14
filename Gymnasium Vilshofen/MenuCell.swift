//
//  MenuCell.swift
//  Gymnasium Vilshofen
//
//  Created by Michael Mayerhofer on 14.10.2014.
//  Copyright (c) 2014 4mayerhofers. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var meal: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
