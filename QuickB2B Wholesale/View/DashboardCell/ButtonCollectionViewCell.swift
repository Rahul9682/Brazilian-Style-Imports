//
//  ButtonCollectionViewCell.swift
//  QuickB2BWholesale
//
//  Created by Sazid Saifi on 21/07/23.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {

    //MARK: -> Outlet’s
      
    @IBOutlet weak var reviewOrderButton: UIButton!
    
    //MARK: -> Properties
    var reviewOrderClick: (() ->Void)?
      
    //MARK: -> LifeCycle
      override func awakeFromNib() {
          super.awakeFromNib()
          configureUI()
      }

  //MARK: -> Helpers
    func configureUI() {
        reviewOrderButton.layer.cornerRadius = 4
    }

  //MARK: -> Button Actions
    @IBAction func reviewOrderButton(_ sender: UIButton) {
        reviewOrderClick?()
    }
}
