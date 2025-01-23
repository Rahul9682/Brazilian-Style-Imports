//
//  RequestAnAccountStatementTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/19/21.
//

import UIKit

class RequestAnAccountStatementTableViewCell: UITableViewCell {

    //MARK:- Properties
    
    var btnRequestAccount: (() -> ())?
    @IBOutlet var requestAnAccountButtoon: UIButton!
    
    //MARK:- LifeCycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK:- BUTTON ACTION
    
    @IBAction func requestAnAccountStatement(_ sender: Any) {
        btnRequestAccount?()
        
    }
    
}
