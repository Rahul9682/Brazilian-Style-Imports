//
//  ManageSuppliersTableViewCell.swift
//  QuickB2BWholesale
//
//  Created by braintech on 21/07/21.
//

import UIKit

class ManageSuppliersTableViewCell: UITableViewCell {
    
    //MARK:- Outlets

    @IBOutlet weak var supplierNameLabel: RegularLabelSize16!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Configure UI Method
    
    func configureUI(with items:String){
        supplierNameLabel.text = items
    }
}
