//
//  NewsCell.swift
//  Gymnasium Vilshofen
//
//  Created by Michael Mayerhofer on 14.10.2014.
//  Copyright (c) 2014 4mayerhofers. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var news: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.news = UILabel(frame: CGRectMake(10, 10, UIScreen.mainScreen().bounds.size.width - 20, 20))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellText(text:String) {
        self.news.text = text
        self.news.numberOfLines = 0
        self.news.font = UIFont (name: "Helvetica Neue", size: 14)
        
        var expected: CGSize = self.news.sizeThatFits(CGSizeMake(self.news.bounds.size.width, CGFloat.max))
        self.news.frame = CGRectMake(10, 10, expected.width, expected.height)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, expected.height + 20)
    }
}