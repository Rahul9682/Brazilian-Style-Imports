//
//  EmailCallTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 5/19/21.
//

import UIKit

class EmailCallTableViewCell: UITableViewCell {
    
    //MARK:- Properties
   
    var btnEmail: (() -> ())?
    var btnCall: (() -> ())?
    @IBOutlet var viewContactMyAccount: UIView!
    @IBOutlet var callButtonTopConst: NSLayoutConstraint!
    @IBOutlet var emailButtonTopConst: NSLayoutConstraint!
    @IBOutlet var callButtonHeightConst: NSLayoutConstraint!
    @IBOutlet var emailButtonHeightConst: NSLayoutConstraint!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var callButton: UIButton!
    
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
    
    @IBAction func emailButton(_ sender: UIButton) {
        btnEmail?()
    }
    
    
    @IBAction func callButton(_ sender: UIButton) {
        btnCall?()
    }
    
    
}
