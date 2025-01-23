//
//  MenuV3Header.swift
//  QuickB2BWholesale
//
//  Created by Sazid Saifi on 27/06/23.
//

import UIKit

class MenuV3Header: UITableViewCell {

    @IBOutlet weak var userNameLabel: RegularLabelSize14!
    @IBOutlet weak var emailLabel: RegularLabelSize14!
    
    var didClickCancel:(()->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        didClickCancel?()
    }
}
