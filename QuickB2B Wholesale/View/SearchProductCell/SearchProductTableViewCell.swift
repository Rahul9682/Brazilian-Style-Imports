//
//  SearchProductTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/14/21.
//

import UIKit

class SearchProductTableViewCell: UITableViewCell {

    //MARK:- Properties
    @IBOutlet var itemsToAddLabel: UILabel!
    @IBOutlet var addToListButton: UIButton!
    @IBOutlet var showItemDataButton: UIButton!
    
    var btnAddItemToList: (() -> ())?
    var btnShowItemData: (() -> ())?
    
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
    
    @IBAction func addItemToListButton(_ sender: UIButton) {
        btnAddItemToList?()
    }
    
    @IBAction func showItemDataButton(_ sender: UIButton) {
        btnShowItemData?()
    }
    
}
