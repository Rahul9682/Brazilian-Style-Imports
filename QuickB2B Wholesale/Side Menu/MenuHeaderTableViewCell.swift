//
//  MenuHeaderTableViewCell.swift
//  Thaizzle
//
//  Created by Gopabandhu on 10/12/20.
//  Copyright © 2020 Gopabandhu. All rights reserved.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var featuredContainerView: UIView!
    @IBOutlet weak var myProductContainerView: UIView!
    @IBOutlet weak var searchProductView: UIView!
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var myProductListImageView: UIImageView!
    @IBOutlet weak var searchProductImageView: UIImageView!
    @IBOutlet weak var featuredButton: UIButton!
    
    //MARK: Properties
    var didClickFeaturedButton: (() -> Void)?
    var didClickMyProductButton: (() -> Void)?
    var didClickSearchProductButton: (() -> Void)?
    
    //MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Helpers
    func configureUI() {
        featuredContainerView.layer.borderWidth = 1
        featuredContainerView.layer.borderColor = UIColor.black.cgColor
        myProductContainerView.layer.borderWidth = 1
        myProductContainerView.layer.borderColor = UIColor.black.cgColor
        searchProductView.layer.borderWidth = 1
        searchProductView.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: Button Action
    @IBAction func featuredButton(_ sender: UIButton) {
        didClickFeaturedButton?()
    }
    
    @IBAction func myProductListButton(_ sender: UIButton) {
        didClickMyProductButton?()
    }
    
    @IBAction func searchProductButton(_ sender: UIButton) {
        didClickSearchProductButton?()
    }
}
