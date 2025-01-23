//  OrderDetailsTableViewCell.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/18/21.

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var containerView: UIView!
    var btnExpandRow: (() -> ())?
    @IBOutlet var expandRowButton: UIButton!
    @IBOutlet var dropDownImage: UIImageView!
    @IBOutlet var orderIDLabel: UILabel!
    @IBOutlet var orderTimeLabel: UILabel!
    @IBOutlet var orderDateLabel: UILabel!
    @IBOutlet weak var reOrderButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderIdLeadingCont: NSLayoutConstraint!
    
    //MARK: - Properties
    var didClickReorder: (() -> ())?
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
        orderIDLabel.font = UIFont(name: "OpenSans-SemiBold", size: 15)
        orderTimeLabel.font = UIFont(name: "OpenSans-SemiBold", size: 15)
        orderDateLabel.font = UIFont(name: "OpenSans-SemiBold", size: 15)
        statusLabel.font = UIFont(name: "OpenSans-SemiBold", size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //Configure the view for the selected state
    }
    
    //MARK: - Helpers
    func configureDropDownImage(isExpand: Bool) {
        dropDownImage.isHidden = true
        orderIDLabel.textAlignment = .center
        if isExpand {
            //dropDownImage.isHidden = false
            orderIdLeadingCont.constant = 4
            //orderIDLabel.textAlignment = .right
            containerView.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        } else {
          //  dropDownImage.isHidden = true
            orderIdLeadingCont.constant = 4
            //orderIDLabel.textAlignment = .center
            containerView.backgroundColor = UIColor.white
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func expandRowButton(_ sender: UIButton) {
        btnExpandRow?()
    }
    
    @IBAction func reOrderButton(_ sender: UIButton) {
        didClickReorder?()
    }
}
