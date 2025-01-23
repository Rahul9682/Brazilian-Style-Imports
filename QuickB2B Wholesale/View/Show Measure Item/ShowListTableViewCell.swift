//
//  ShowListTableViewCell.swift
//  QuickB2B
//
//  Created by Braintech on 12/09/24.
//

import UIKit

class ShowListTableViewCell: UITableViewCell {
    
    //MARK: - Outlet's
    @IBOutlet weak var orginQuantityLabel: UITextField!
    @IBOutlet weak var measureLabel: UITextField!
    @IBOutlet weak var crossImageView: UIImageView!
    @IBOutlet weak var addView: UIView!
    
    //MARK: - Properties
    var delegate: ShowListTableViewCellDelegate?
    var delegeteMyListSuccess:DelegeteMyListSuccess?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        confiqureUI()
    }
    
    private func confiqureUI() {
        orginQuantityLabel.addBorderLayer()
        measureLabel.addBorderLayer()
        orginQuantityLabel.isUserInteractionEnabled = false
        measureLabel.isUserInteractionEnabled = false
        if let rotatedImage = Constants.rotateImageInPlace(image: UIImage(named: "plus1") ?? UIImage(), byDegrees: 45) {
            crossImageView.image = rotatedImage
            crossImageView.tintColor = UIColor.lightGray
            crossImageView.alpha = 0.5
        }
        
       
    }
    
    func confiqureUI(itemData: GetItemsData, showAddView: Bool) {
        if let unit = itemData.measureQty {
            if unit == "" {
                measureLabel.text = ""
                measureLabel.placeholder  = "QTY"
            } else {
                let floatUnit = (unit as NSString).floatValue
                let strTotalPrice:NSString = NSString(format: "%.2f", floatUnit)
                let strTottalPrice:String = strTotalPrice as String
                measureLabel.text = strTottalPrice
            }
            
        } else {
            print("else")
            measureLabel.text = ""
            measureLabel.placeholder  = "QTY"
        }
        
        if let origin = itemData.originQty {
            if origin == "" {
                orginQuantityLabel.text = ""
                orginQuantityLabel.placeholder = itemData.uom
            } else {
                let floatOrigin = (origin as NSString).floatValue
                let strTotalPrice:NSString = NSString(format: "%.2f", floatOrigin)
                let strTottalPrice:String = strTotalPrice as String
                orginQuantityLabel.text = strTottalPrice
            }
        } else {
            orginQuantityLabel.text = ""
            orginQuantityLabel.placeholder = itemData.uom
        }
        
        if showAddView {
            addView.isHidden = false
            if orginQuantityLabel.text == "" || measureLabel.text == "" {
                orginQuantityLabel.isUserInteractionEnabled = true
                measureLabel.isUserInteractionEnabled = true
            } else {
                orginQuantityLabel.isUserInteractionEnabled = false
                measureLabel.isUserInteractionEnabled = false
            }
        } else {
            orginQuantityLabel.isUserInteractionEnabled = false
            measureLabel.isUserInteractionEnabled = false
            addView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        if let delegate = delegate {
            delegate.addButtonTapped()
        }
    }
    
}


