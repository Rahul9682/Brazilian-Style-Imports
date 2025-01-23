//
//  TitleTableViewCell.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 19/04/23.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sellAllButton: UIButton!
    @IBOutlet weak var titleLabel: SemiBoldLabelSize16!
    @IBOutlet weak var spcingheightConst: NSLayoutConstraint!
    @IBOutlet weak var containerViewTopConst: NSLayoutConstraint!
    
    //MARK: -> Properties
    var didClickSeeAll: (() -> Void)?
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    func configureSellAllButton(isShow: Bool) {
        if isShow {
            sellAllButton.isHidden = false
        } else {
            sellAllButton.isHidden = true
        }
    }
    
    //MARK: -> Button Actions
    
    @IBAction func sellAllButton(_ sender: UIButton) {
        didClickSeeAll?()
    }
}
