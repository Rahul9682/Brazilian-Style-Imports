//
//  OrderedItemTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/18/21.
//

import UIKit

class OrderedItemTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemQuantityLabel: UILabel!
    @IBOutlet weak var reOrderButton: UIButton!
    
    //MARK: -> Properties
    var didClickReorder: (() -> Void)?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        itemNameLabel.font = UIFont(name: "OpenSans-Regular", size: 13)
        itemQuantityLabel.font = UIFont(name: "OpenSans-Regular", size: 13)
        reOrderButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Button Actions
    @IBAction func reOrderButton(_ sender: UIButton) {
        didClickReorder?()
    }
}

