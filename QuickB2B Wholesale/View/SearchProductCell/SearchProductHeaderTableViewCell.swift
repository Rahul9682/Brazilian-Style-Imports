//
//  SearchProductHeaderTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/14/21.
//

import UIKit

class SearchProductHeaderTableViewCell: UITableViewCell {

    
    //MARK:- Properties
   
    var btnSearchItem: (() -> ())?
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
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
    
    @IBAction func searchButton(_ sender: UIButton) {
        btnSearchItem?()
    }
}
