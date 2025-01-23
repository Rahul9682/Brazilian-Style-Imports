//  ItemTableViewCellWithImage.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/21/21.

import UIKit

class ItemTableViewCellWithImage: UITableViewCell {
    
    //MARK: - Outlets's
    @IBOutlet var specialIItemLabel: UILabel!
    @IBOutlet var itemLabel: SemiBoldLabelSize12!
    @IBOutlet var priceLabel: SemiBoldLabelSize12!
    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var inactiveLabel: SemiBoldLabelSize14!
    @IBOutlet var showItemDataButton: UIButton!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var addContainerView: UIView!
    @IBOutlet weak var productImageHeihtConstarint: NSLayoutConstraint!
    @IBOutlet weak var itemNameLabelLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var productImageWidthConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var productImageButtonWidthConstarint: NSLayoutConstraint!
    @IBOutlet weak var productImageButtonHeihtConstarint: NSLayoutConstraint!
    @IBOutlet weak var itemLabelTopConst: NSLayoutConstraint!
    @IBOutlet weak var measureTexfield: UITextField!    
    @IBOutlet weak var addIconWIdthConstraint: NSLayoutConstraint!
    @IBOutlet weak var addListView: UIView!
    @IBOutlet weak var showListView: UIView!
    @IBOutlet weak var measureTexfieldConstraints: NSLayoutConstraint!
    @IBOutlet weak var measureTexfieldTrailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var measureLabel: UILabel!
    
    //MARK: - Properties
    
    var didClickShowList: (() ->Void)?
    var didClickAdd: (() ->Void)?
    var didChangeQuantity: (( _ value: String)->())?
    var btnShowItemData: (() -> ())?
    var delegeteMyListSuccess:DelegeteMyListSuccess?
    var index: Int = 0
    var addItemButton: (() -> Void)?
    var didClickProduct: (() ->Void)?
    var didClickProductNameLabel: (() ->Void)?
    
    @IBOutlet weak var itemLabeltrailingConst: NSLayoutConstraint!
    
    override open var frame: CGRect {
       get {
           return super.frame
       }
       set {
           var frame =  newValue
           frame.size.height -= 8
           super.frame = frame
       }
   }
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        measureTexfield.delegate = self
        measureTexfield.layer.borderWidth = 0.5
        measureTexfield.layer.cornerRadius = 5
        measureTexfield.layer.borderColor = UIColor.lightGray.cgColor
        quantityTextField.delegate = self
        quantityTextField.layer.borderWidth = 0.5
        quantityTextField.layer.cornerRadius = 5
        quantityTextField.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.MyTheme.dropShadowColor.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapProductLabel))
        itemLabel.addGestureRecognizer(tapGesture)
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTag(tag: Int){
        quantityTextField.tag = 100+tag
    }
    
    @objc func tapProductLabel (sender: UITapGestureRecognizer) {
        didClickProductNameLabel?()
    }
    
    //MARK: -> configure-Product Visibility
    func configureShowImage(isShow: String) {
        if isShow == "1" {
            itemLabel.isUserInteractionEnabled = false
            productImageHeihtConstarint.constant = 75
            productImageWidthConstarint.constant = 125
            productImageButtonHeihtConstarint.constant = 75
            productImageButtonWidthConstarint.constant = 125
            itemNameLabelLeadingConst.constant = 20
            itemLabel.textAlignment = .right
            itemLabelTopConst.constant = 2
            itemLabeltrailingConst.constant = 10
        } else {
            itemLabel.isUserInteractionEnabled = true
            productImageHeihtConstarint.constant = 0
            productImageWidthConstarint.constant = 0
            itemNameLabelLeadingConst.constant = 8
            productImageButtonHeihtConstarint.constant = 0
            productImageButtonWidthConstarint.constant = 0
            itemLabel.textAlignment = .left
            
            itemLabelTopConst.constant = -28
            itemLabeltrailingConst.constant = 110
            // Apply Auto Layout constraints
            NSLayoutConstraint.activate([
                itemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
        }
    }
    
    func configureIsMeasureShow(isMeasure: Int) {
        if isMeasure == 0 {
            measureTexfield.isHidden = true
            showListView.isHidden = true
            addListView.isHidden = true
            measureTexfieldConstraints.constant = 0
           // measureTexfieldTrailingConstraints.constant = 0
        } else {
            measureTexfield.isHidden = false
            showListView.isHidden = false
            addListView.isHidden = false
            measureTexfieldConstraints.constant = 55
           // measureTexfieldTrailingConstraints.constant = 8
        }
        
    }
    
    //MARK: - TEXTFIELD ACTION
    @IBAction func txtQuantityDidChange(_ sender: UITextField) {
        didChangeQuantity?(sender.text ?? "")
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func showItemDataButton(_ sender: UIButton) {
        didClickProduct?()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        addItemButton?()
    }
    
    
    @IBAction func showListAction(_ sender: Any) {
        didClickShowList?()
    }
    
    
    @IBAction func AddToListAction(_ sender: Any) {
        didClickAdd?()
    }
}

//MARK: -> UITextFieldDelegate
extension ItemTableViewCellWithImage: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // Combine the current text with the replacement text
        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)
        // Regular expression to match the allowed format
        let regex = try! NSRegularExpression(pattern: "^\\d{0,4}(\\.\\d{0,2})?$")
        let range = NSRange(location: 0, length: updatedText.utf16.count)
        if regex.firstMatch(in: updatedText, options: [], range: range) == nil {
            return false // Don't allow the change
        }
        return true
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = getCell(for: textField) {
            if cell.measureTexfield.isHidden != true {
                if let measureTextField = cell.measureTexfield.text, let quantityTextField = cell.quantityTextField.text {
                    if quantityTextField != "" && measureTextField != "" && quantityTextField != "0" && quantityTextField != "0.0" && quantityTextField != "0.00" && measureTextField != "0" && measureTextField != "0.0" && measureTextField != "0.00" {
                        if let delegeteMyListSuccess = delegeteMyListSuccess {
                            delegeteMyListSuccess.isSuceess(success: true, text:  quantityTextField, index: textField.tag, measureQty: measureTextField)
                        }
                    } else {
                        if (quantityTextField == "" && measureTextField == "" ) || (quantityTextField == "0" && measureTextField == "0"){
                            if let delegeteMyListSuccess = delegeteMyListSuccess {
                                delegeteMyListSuccess.isSuceess(success: true, text: "0", index: textField.tag, measureQty: "0")
                            }
                        }
                    }
                } else {
                    
                }
            } else {
                if let quantityTextField = cell.quantityTextField.text {
                    if quantityTextField != ""  {
                        if let delegeteMyListSuccess = delegeteMyListSuccess {
                            delegeteMyListSuccess.isSuceess(success: true, text: quantityTextField, index: textField.tag, measureQty: "1")
                        }
                    }  else {
                        if let delegeteMyListSuccess = delegeteMyListSuccess {
                            delegeteMyListSuccess.isSuceess(success: true, text: "0", index: textField.tag, measureQty: "0")
                        }
                    }
                }
            }
        } else {
            print("not found")
        }
    }
    
    
    func getCell(for textField: UITextField) -> ItemTableViewCellWithImage? {
        var view: UIView? = textField
        while let superview = view?.superview {
            if let cell = superview as? ItemTableViewCellWithImage {
                return cell
            }
            view = superview
        }
        return nil
    }
}
