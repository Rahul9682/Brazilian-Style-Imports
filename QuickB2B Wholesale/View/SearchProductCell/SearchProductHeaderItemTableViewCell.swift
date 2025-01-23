//
//  SearchProductHeaderItemTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/15/21.
//

import UIKit

class SearchProductHeaderItemTableViewCell: UITableViewCell {

    //MARK:- Properties
    
    @IBOutlet var viewItems: UIView!
    @IBOutlet var expandRowButton: UIButton!
    @IBOutlet var itemsLabel: UILabel!
    var btnExpandRow: (() -> ())?
    //MARK:- Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- BUTTON ACTION
    
    @IBAction func expandRowButton(_ sender: UIButton) {
        btnExpandRow?()
    }
}
