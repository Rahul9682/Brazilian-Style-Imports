//
//  CustomerListTableViewCell.swift
//  QuickB2B
//
//  Created by Braintech on 24/10/24.
//

import UIKit

class CustomerListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var custmerName: UILabel!
    @IBOutlet weak var customerCode: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // containerView.layer.cornerRadius = Radius.searchViewRadius
       // containerView.layer.borderWidth = Radius.searchViewborderWidth
       // containerView.layer.borderColor = hexStringToUIColor(hex: "2497A0").cgColor
        customerCode.font = UIFont.init(name: "OpenSans-SemiBold" , size: 14)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
