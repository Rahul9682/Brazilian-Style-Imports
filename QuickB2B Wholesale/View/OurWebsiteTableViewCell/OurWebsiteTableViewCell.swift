//
//  OurWebsiteTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/19/21.
//

import UIKit

class OurWebsiteTableViewCell: UITableViewCell {
    
    //MARK:- Properties
    
    @IBOutlet var websiteLinkLabel: UILabel!
    
    @IBOutlet var ourWebsiteHeightConst: NSLayoutConstraint!
    
    //MARK:- LifeCycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
