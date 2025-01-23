//
//  ButtonTableViewCell.swift
//  QuickB2BWholesale
//
//  Created by Sazid Saifi on 21/07/23.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    //MARK: -> Outlet’s
    @IBOutlet weak var reviewOrderButton: UIButton!
    
    //MARK: -> Properties
    var reviewOrderClick: (() ->Void)?
      
   //MARK: -> LifeCycle
      override func awakeFromNib() {
          super.awakeFromNib()
          configureUI()
      }

      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
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
