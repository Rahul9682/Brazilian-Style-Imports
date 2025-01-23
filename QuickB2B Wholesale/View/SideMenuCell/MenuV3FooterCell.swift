//  MenuV3FooterCell.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 27/06/23.

import UIKit

class MenuV3FooterCell: UITableViewCell {

    @IBOutlet weak var logoutLabel: SemiBoldLabelSize14!
    @IBOutlet weak var containerView: UIView!
    var didClickLogoutButton:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.red.cgColor
        containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        didClickLogoutButton?()
    }
}
