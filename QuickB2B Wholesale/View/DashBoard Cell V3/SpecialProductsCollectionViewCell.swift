//  SpecialProductsCollectionViewCell.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit
import SDWebImage

class SpecialProductsCollectionViewCell: UICollectionViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerVIew: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: SemiBoldLabelSize14!
    @IBOutlet weak var priceLabel: SemiBoldLabelSize14!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var addIconImageView: UIImageView!
    @IBOutlet weak var productImageHeihtConstarint: NSLayoutConstraint!
    @IBOutlet weak var inactiveLabel: SemiBoldLabelSize12!
    @IBOutlet weak var addButtonContainerVIew: UIView!
    @IBOutlet weak var favoriteViewWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var measureTextField: UITextField!
    @IBOutlet weak var addChipsView: UIView!
    @IBOutlet weak var showListView: UIView!
    @IBOutlet weak var crossImageView: UIImageView!
    @IBOutlet weak var multiItemCount: UILabel!
    
    @IBOutlet weak var measureTextFieldWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var textFieldContainerViewWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var crossImageWidthConstraints: NSLayoutConstraint!
    
    //MARK: -> Properties
   
    var didClickAddItemToCart: (() ->Void)?
    var didClickShowList: (() ->Void)?
    var didClickAdd: (() ->Void)?
    var qauntity: ((String) ->Void)?
    var delegeteMyListSuccess:DelegeteMyListSuccess?
    var getIndex:GetProductClickIndex?
    //var index: Int = 0
    //var didChangeText: (() ->Void)?
    var arrayOfLocalStorage = LocalStorage.getItemsData()
    var didClickProduct: (() ->Void)?
    var didClickProductNameLabel: (() ->Void)?
    //var redColor: UIColor = UIColor(red: 237.0/255, green: 35.0/255, blue: 35.0/255, alpha: 1.0)
    var is_meas_box = 0
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        quantityTextField.layer.borderColor = AppColors.redTextColor.cgColor
        addIconImageView.tintColor = UIColor.lightGray
        quantityTextField.delegate = self
        measureTextField.delegate = self
        inactiveLabel.textColor = AppColors.redTextColor
        containerVIew.dropShadow()
        measureTextField.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapProductLabel))
        productNameLabel.addGestureRecognizer(tapGesture)
        
        if let rotatedImage = Constants.rotateImageInPlace(image: UIImage(named: "plus1") ?? UIImage(), byDegrees: 45) {
            crossImageView.image = rotatedImage
            crossImageView.tintColor = UIColor.lightGray
            crossImageView.alpha = 0.5
        }
        
        measureTextField.layer.borderWidth = 0.5;
        measureTextField.layer.cornerRadius = 5;
        measureTextField.layer.borderColor = UIColor.lightGray.cgColor;
        measureTextField.textColor = UIColor.black
    }
    
    @objc func tapProductLabel (sender: UITapGestureRecognizer) {
        didClickProductNameLabel?()
    }
    
    //MARK: -> configure-Product Visibility
    func configureShowImage(isShow: String) {
        if isShow == "1" {
            productNameLabel.isUserInteractionEnabled = false
            productImageHeihtConstarint.constant = 76
        } else {
            productNameLabel.isUserInteractionEnabled = true
            productImageHeihtConstarint.constant = 0
        }
    }

    //MARK: -> configure-Home-Data
    func configureHomeData(data: GetItemsData, showImage: String, showPrice: String) {
        configureShowImage(isShow: showImage)
        containerVIew.dropShadow()
        quantityTextField.isHidden = false
        inactiveLabel.isHidden = true
        inactiveLabel.text = ""
        //quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
        // addButtonContainerVIew.isHidden = true
        inactiveLabel.textColor = AppColors.redTextColor
        quantityTextField.isEnabled  = true
        //cell.quantityTextField.tag = indexPath.row
        
        if let strUOM = data.uom {
            quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM, attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray])
          
        }
        
        measureTextField.attributedPlaceholder = NSAttributedString(string: "QTY", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        if let unit = Constants.getMeasure(itemCode: data.item_code) {
            if unit == "0" || unit == "0.00" || unit == "0.0" || unit == "" {
                measureTextField.placeholder = "QTY"
            } else {
                let floatQuantity = (unit as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                measureTextField.text  = strQuantity as String
            }
        } else {
            measureTextField.text =  ""
        }
        
        if let showUnit = data.is_meas_box {
            if showUnit == 1 {
                measureTextField.isHidden = false
                addChipsView.isHidden = false
                showListView.isHidden = false
                crossImageView.isHidden = false
                measureTextFieldWidthConstraints.constant = 50
                crossImageWidthConstraints.constant = 22
                textFieldContainerViewWidthConstraints.constant = 122
                
            } else {
                measureTextField.isHidden = true
                addChipsView.isHidden = true
                showListView.isHidden = true
                crossImageView.isHidden = true
                measureTextFieldWidthConstraints.constant = 0
                crossImageWidthConstraints.constant = 0
                textFieldContainerViewWidthConstraints.constant = 60
               
            }
            self.is_meas_box = showUnit
        }
        
        if let itemName = data.item_name {
            if(itemName != "") {
                productNameLabel.text = itemName
            }
        }
        
//        if let image = data.image {
//            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
//        } else {
//            productImageView.image = Icons.placeholderImage
//        }
        if let thumb_image = data.thumb_image {
            productImageView.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else if let image = data.image {
            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            productImageView.image = Icons.placeholderImage
        }
        
        if let itemPrice = data.item_price {
            let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
            priceLabel.text =  currencySymbol + String(itemPrice)
        }
        
        if let strQuantity =  Constants.getPrice(itemCode: data.item_code){
            let Intprice = Int(strQuantity)
            if (Intprice == 0) {
                if (data.special_title == 1){
                    quantityTextField.text = ""
                }
                else {
                    if (data.uom?.count == 0){
                        quantityTextField.text = "0"
                    }
                    else {
                        quantityTextField.text = ""
                    }
                }
            } else if strQuantity == "" {
                quantityTextField.text = ""
            } else {
                let floatQuantity = (strQuantity as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                quantityTextField.text  = strQuantity as String
            }
        } else {
            quantityTextField.text = ""
        }
        
        
        if let specialItemID = data.special_item_id {
            if (specialItemID == 1) {
                priceLabel.textColor = AppColors.redTextColor
                if let strQuantity = data.quantity {
                    if (strQuantity == "0.00" || strQuantity == "0") {
                        favouriteButton.isHidden = false
                        favoriteViewWidthConstraints.constant = 18
                    }
                } else {
                    priceLabel.textColor = UIColor.black
                    favouriteButton.isHidden = true
                    favoriteViewWidthConstraints.constant = 18
                }
            }
            else {
                priceLabel.textColor = UIColor.black
                favouriteButton.isHidden = true
                favoriteViewWidthConstraints.constant = 18
            }
        }
        
        if let status = data.status {
            if(status != "Active") {
                inactiveLabel.text = "NA"
                inactiveLabel.isHidden = false
                quantityTextField.isHidden = true
                //priceLabel.isHidden  = true
                priceLabel.text = ""
                //specialIItemLabel.isHidden = true
                productNameLabel.isHidden = false
            } else {
                quantityTextField.layer.borderWidth = 0.5;
                quantityTextField.layer.cornerRadius = 5;
                quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
                quantityTextField.textColor = UIColor.black
                if let specialItemID = data.special_item_id {
                    if (specialItemID == 1) {
                        //specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                        quantityTextField.isEnabled = true
                    }
                    else {
                        //cell.specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        quantityTextField.isEnabled = true
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                    }
                } }}
        else {
            inactiveLabel.text = "NA"
            inactiveLabel.isHidden = false
            quantityTextField.isHidden = true
            //            priceLabel.isHidden  = true
            priceLabel.text = ""
            //cell.specialIItemLabel.isHidden = true
            productNameLabel.isHidden = true
        }
        
        if(showPrice == "0") {
            if let specialItemID = data.special_item_id {
                if( specialItemID == 1){
                    priceLabel.textColor = AppColors.redTextColor
                    priceLabel.isHidden = false
                } else {
                    priceLabel.textColor = UIColor.black
                    //                    priceLabel.isHidden = true
                    priceLabel.text = ""
                }
            }
        } else {
            if let specialItemID = data.special_item_id {
                if( specialItemID == 1){
                    priceLabel.textColor = AppColors.redTextColor
                    if let status = data.status {
                        if(status != "Active") {
                            //                            priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                } else {
                    priceLabel.textColor = UIColor.black
                    if let status = data.status {
                        if(status != "Active") {
                            //                            priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        if let specialTitle = data.special_title {
            if(specialTitle == 1) {
                //viewModel.specialItemIndex = indexPath.row
                //cell.specialIItemLabel.text = viewModel.arrItemsData[indexPath.row].item_name
                // cell.specialIItemLabel.isHidden = false
                productNameLabel.isHidden = true
                quantityTextField.isHidden = true
                //                priceLabel.isHidden = true
                priceLabel.text = ""
                favouriteButton.isHidden  = false
                favoriteViewWidthConstraints.constant = 18
                //productImageView.isHidden = true
            }
        }
    }
    
    
    //MARK: -> configure-ProductLis-Data
    func configureHomeProductListData(data: GetItemsData, showImage: String, showPrice: String) {
        configureShowImage(isShow: showImage)
        containerVIew.dropShadow()
        quantityTextField.isHidden = false
        inactiveLabel.isHidden = true
        inactiveLabel.text = ""
        addButtonContainerVIew.isHidden = false
        addIconImageView.image = Icons.remove
        //quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
        inactiveLabel.textColor = AppColors.redTextColor
        quantityTextField.isEnabled  = true
        //cell.quantityTextField.tag = indexPath.row
        
        
        if data.inMyList == 0 {
            addIconImageView.image = Icons.add
            addIconImageView.isHidden = true
            addButtonContainerVIew.isHidden = true
        } else {
            addIconImageView.image = Icons.remove
            addIconImageView.isHidden = false
            addButtonContainerVIew.isHidden = false
        }
        
        if let strUOM = data.uom {
            quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM, attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
        }
        
        //crossImageView.tintColor = UIColor.lightGray
    
        measureTextField.attributedPlaceholder = NSAttributedString(string: "QTY", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        if let showUnit = data.is_meas_box {
            if showUnit == 1 {
                measureTextField.isHidden = false
                addChipsView.isHidden = false
                showListView.isHidden = false
                crossImageView.isHidden = false
                measureTextFieldWidthConstraints.constant = 50
                crossImageWidthConstraints.constant = 22
                textFieldContainerViewWidthConstraints.constant = 122
                
            } else {
                measureTextField.isHidden = true
                addChipsView.isHidden = true
                showListView.isHidden = true
                crossImageView.isHidden = true
                measureTextFieldWidthConstraints.constant = 0
                crossImageWidthConstraints.constant = 0
                textFieldContainerViewWidthConstraints.constant = 60
               
            }
        }
        
        if let unit =  Constants.getMeasure(itemCode: data.item_code){
            if unit == "0" || unit == "0.00" || unit == "0.0" || unit == "" {
                measureTextField.placeholder = "QTY"
            } else {
                let floatQuantity = (unit as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                measureTextField.text  = strQuantity as String
            }
        } else {
            measureTextField.text = ""
        }
        
        if let itemName = data.item_name {
            if(itemName != "") {
                productNameLabel.text = itemName
            }
        }
 
//        if let image = data.image {
//            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
//        } else {
//            productImageView.image = Icons.placeholderImage
//        }
        
        if let thumb_image = data.thumb_image {
            productImageView.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else if let image = data.image {
            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            productImageView.image = Icons.placeholderImage
        }
        
        
        if let itemPrice = data.item_price {
            let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
            priceLabel.text =  currencySymbol + String(itemPrice)
        }
        
        if let strQuantity =   Constants.getPrice(itemCode: data.item_code) {
            let Intprice = Int(strQuantity)
            if (Intprice == 0) {
                if (data.special_title == 1)  {
                    quantityTextField.text = "";
                }
                else {
                    if (data.uom?.count == 0) {
                        quantityTextField.text = "0";
                    }
                    else {
                        quantityTextField.text = "";
                    }
                }
            } else if strQuantity == "" {
                quantityTextField.text = ""
            } else {
                let floatQuantity = (strQuantity as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                quantityTextField.text  = strQuantity as String
            }
        } else {
            quantityTextField.text = ""
        }
        
        if let specialItemID = data.special_item_id {
            if (specialItemID == 1) {
                priceLabel.textColor = AppColors.redTextColor
                if let strQuantity = data.quantity {
                    if (strQuantity == "0.00" || strQuantity == "0") {
                        favouriteButton.isHidden = false
                        favoriteViewWidthConstraints.constant = 18
                    }
                } else {
                    favouriteButton.isHidden = true
                    favoriteViewWidthConstraints.constant = 18
                }
                addButtonContainerVIew.isHidden = true
            }
            else {
                priceLabel.textColor = UIColor.black
                favouriteButton.isHidden = true
                favoriteViewWidthConstraints.constant = 18
                addButtonContainerVIew.isHidden = false
            }
        }
        
        if let status = data.status {
            if(status != "Active") {
                inactiveLabel.text = "NA"
                inactiveLabel.isHidden = false
                quantityTextField.isHidden = true
                //                priceLabel.isHidden  = true
                priceLabel.text = ""
                //specialIItemLabel.isHidden = true
                productNameLabel.isHidden = false
            } else {
                quantityTextField.layer.borderWidth = 0.5
                quantityTextField.layer.cornerRadius = 5
                quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
                quantityTextField.textColor = UIColor.black
                if let specialItemID = data.special_item_id {
                    if (specialItemID == 1)  {
                        //specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                        quantityTextField.isEnabled = true
                    }
                    else {
                        //cell.specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        quantityTextField.isEnabled = true
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                    }
                } }}
        else {
            inactiveLabel.text = "NA"
            inactiveLabel.isHidden = false
            quantityTextField.isHidden = true
            //            priceLabel.isHidden  = true
            priceLabel.text = ""
            //cell.specialIItemLabel.isHidden = true
            productNameLabel.isHidden = true
        }
        
        if(showPrice == "0") {
            if let specialItemID = data.special_item_id {
                if( specialItemID == 1) {
                    priceLabel.textColor = AppColors.redTextColor
                    priceLabel.isHidden = false
                } else {
                    priceLabel.textColor = UIColor.black
                    //                    priceLabel.isHidden = true
                    priceLabel.text = ""
                }
            }
        } else {
            if let specialItemID = data.special_item_id {
                if( specialItemID == 1) {
                    priceLabel.textColor = AppColors.redTextColor
                    if let status = data.status {
                        if(status != "Active") {
                            //                            priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                } else {
                    priceLabel.textColor = UIColor.black
                    if let status = data.status {
                        if(status != "Active") {
                            //                            priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        if let specialTitle = data.special_title {
            if(specialTitle == 1) {
                //viewModel.specialItemIndex = indexPath.row
                //cell.specialIItemLabel.text = viewModel.arrItemsData[indexPath.row].item_name
                // cell.specialIItemLabel.isHidden = false
                productNameLabel.isHidden = true
                quantityTextField.isHidden = true
                //                priceLabel.isHidden = true
                priceLabel.text = ""
                
                favouriteButton.isHidden  = false
                favoriteViewWidthConstraints.constant = 18
                //productImageView.isHidden = true
            }
        }
    }
    
    //MARK: -> configure-Products-Data
    func configureProductListData(data: GetItemsData?, showPrice: String, showImage: String, showAllItem: Bool) {
        configureShowImage(isShow: showImage)
        inactiveLabel.textColor = AppColors.redTextColor
        quantityTextField.isHidden = false
        inactiveLabel.isHidden = true
        inactiveLabel.text = ""
        inactiveLabel.textColor = AppColors.redTextColor
        quantityTextField.isEnabled  = true
        if showAllItem {
            addButtonContainerVIew.isHidden = true
        } else {
            addButtonContainerVIew.isHidden = false
            if data?.inMyList == 0 {
                addIconImageView.image = Icons.add
                addIconImageView.isHidden = false
                addButtonContainerVIew.isHidden = false
            } else {
                addIconImageView.image = Icons.remove
                addIconImageView.isHidden = true
                addButtonContainerVIew.isHidden = true
            }
        }
        
        if let strUOM = data?.uom {
            quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
           
        }
        
        //crossImageView.tintColor = UIColor.lightGray
        
        measureTextField.attributedPlaceholder = NSAttributedString(string: "QTY",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        if let showUnit = data?.is_meas_box {
            if showUnit == 1 {
                measureTextField.isHidden = false
                addChipsView.isHidden = false
                showListView.isHidden = false
                crossImageView.isHidden = false
                measureTextFieldWidthConstraints.constant = 50
                crossImageWidthConstraints.constant = 22
                textFieldContainerViewWidthConstraints.constant = 122
                
            } else {
                measureTextField.isHidden = true
                addChipsView.isHidden = true
                showListView.isHidden = true
                crossImageView.isHidden = true
                measureTextFieldWidthConstraints.constant = 0
                crossImageWidthConstraints.constant = 0
                textFieldContainerViewWidthConstraints.constant = 60
               
            }
        }
        
        if let itemName = data?.item_name {
            if(itemName != "") {
                productNameLabel.text = itemName
            }
        }
        
//        if let image = data?.image {
//            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
//        } else {
//            productImageView.image = Icons.placeholderImage
//        }
        
        if let thumb_image = data?.thumb_image {
            productImageView.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else if let image = data?.image {
            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            productImageView.image = Icons.placeholderImage
        }
        
        if let unit = Constants.getMeasure(itemCode:  data?.item_code) {
            if unit == "0" || unit == "0.00" || unit == "0.0" || unit == "" {
                measureTextField.placeholder = "QTY"
            } else {
                let floatQuantity = (unit as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                measureTextField.text = strQuantity
            }
        } else {
            measureTextField.text = ""
        }
        
        
        if let itemPrice = data?.item_price {
            let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
            priceLabel.text =  currencySymbol + String(itemPrice)
        }
        
        if let strQuantity = Constants.getPrice(itemCode:  data?.item_code) {
            let Intprice = Int(strQuantity)
            if (Intprice == 0) {
                if (data?.special_title == 1) {
                    quantityTextField.text = ""
                }
                else {
                    if (data?.uom?.count == 0) {
                        quantityTextField.text = "0"
                    }
                    else {
                        quantityTextField.text = ""
                    }
                }
            } else {
                let floatQuantity = (strQuantity as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                quantityTextField.text  = strQuantity as String
            }
        } else {
            quantityTextField.text = ""
        }
        
        if let specialItemID = data?.special_item_id {
            if (specialItemID == 1) {
                priceLabel.textColor = AppColors.redTextColor
                if let strQuantity = data?.quantity {
                    if (strQuantity == "0.00" || strQuantity == "0") {
                        favouriteButton.isHidden = false
                        favoriteViewWidthConstraints.constant = 18
                    }
                } else {
                    favouriteButton.isHidden = true
                    favoriteViewWidthConstraints.constant = 18
                }
            }
            else {
                priceLabel.textColor = UIColor.black
                favouriteButton.isHidden = true
                favoriteViewWidthConstraints.constant = 18
            }
        }
        
        if let status = data?.status {
            if(status != "Active") {
                inactiveLabel.text = "NA"
                inactiveLabel.isHidden = false
                quantityTextField.isHidden = true
                //priceLabel.isHidden  = true
                priceLabel.text = ""
                //specialIItemLabel.isHidden = true
                productNameLabel.isHidden = false
            } else {
                quantityTextField.layer.borderWidth = 0.5;
                quantityTextField.layer.cornerRadius = 5;
                quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
                quantityTextField.textColor = UIColor.black
                if let specialItemID = data?.special_item_id {
                    if (specialItemID == 1) {
                        //specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                        quantityTextField.isEnabled = true
                    }
                    else {
                        //cell.specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        quantityTextField.isEnabled = true
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                    }
                } }}
        else {
            inactiveLabel.text = "NA"
            inactiveLabel.isHidden = false
            quantityTextField.isHidden = true
            //priceLabel.isHidden  = true
            //cell.specialIItemLabel.isHidden = true
            productNameLabel.isHidden = true
        }
        
        if(showPrice == "0") {
            if let specialItemID = data?.special_item_id {
                if( specialItemID == 1){
                    priceLabel.textColor = AppColors.redTextColor
                    priceLabel.isHidden = false
                } else {
                    priceLabel.textColor = UIColor.black
                    //                    priceLabel.isHidden = true
                    priceLabel.text = ""
                }
            }
        } else {
            if let specialItemID = data?.special_item_id {
                if( specialItemID == 1){
                    priceLabel.textColor = AppColors.redTextColor
                    if let status = data?.status {
                        if(status != "Active") {
                            //                            priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                } else {
                    priceLabel.textColor = UIColor.black
                    if let status = data?.status {
                        if(status != "Active") {
                            //                            priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        if let specialTitle = data?.special_title {
            if let specialId = data?.special_item_id {
                if(specialTitle == 1) || (specialId == 1) {
                    //viewModel.specialItemIndex = indexPath.row
                    //specialItemLabel.text = viewModel.arrItemsData[indexPath.row].item_name
                    //cell.specialItemLabel.isHidden = false
                    //productNameLabel.isHidden = true
                    //quantityTextField.isHidden = true
                    //priceLabel.isHidden = true
                    favouriteButton.isHidden  = false
                    favoriteViewWidthConstraints.constant = 18
                    
                } else {
                    //productNameLabel.isHidden = false
                    // quantityTextField.isHidden = false
                    //priceLabel.isHidden = false
                    favouriteButton.isHidden  = true
                    favoriteViewWidthConstraints.constant = 18
                }
            }
        }
    }
    
    
    //MARK: -> configure-MyList-Data
       func configureMyListData(data: GetItemsData, showImage: String, showPrice: String, displayAll: Bool)  {
           
           configureShowImage(isShow: showImage)
           addIconImageView.image = Icons.remove
   //        if let itemImage = data.image {
   //            productImageView.sd_setImage(with: URL(string: itemImage), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
   //        } else {
   //            productImageView.image = Icons.placeholderImage
   //        }
           if let thumb_image = data.thumb_image {
               productImageView.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
           } else if let image = data.image {
               productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
           } else {
               productImageView.image = Icons.placeholderImage
           }
           
           //quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
           quantityTextField.isHidden = true
           inactiveLabel.isHidden = false
           inactiveLabel.text = ""
           quantityTextField.isEnabled  = true
           priceLabel.textColor = UIColor.black
           inactiveLabel.textColor = AppColors.redTextColor
           if let strUOM = data.uom {
               quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
               
           }
           
           measureTextField.attributedPlaceholder = NSAttributedString(string: "QTY",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
           
          // crossImageView.tintColor = UIColor.lightGray
                
           
           if let showUnit = data.is_meas_box {
               if showUnit == 1 {
                   measureTextField.isHidden = false
                   addChipsView.isHidden = false
                   showListView.isHidden = false
                   crossImageView.isHidden = false
                   measureTextFieldWidthConstraints.constant = 50
                   crossImageWidthConstraints.constant = 22
                   textFieldContainerViewWidthConstraints.constant = 122
                
               } else {
                   measureTextField.isHidden = true
                   addChipsView.isHidden = true
                   showListView.isHidden = true
                   crossImageView.isHidden = true
                   measureTextFieldWidthConstraints.constant = 0
                   crossImageWidthConstraints.constant = 0
                   textFieldContainerViewWidthConstraints.constant = 60
                  
               }
               
           }
           
           
           
           if let itemName = data.item_name {
               if(itemName != "") {
                   productNameLabel.text = itemName
               }
           } else {
               productNameLabel.text = ""
           }
           
           if let itemPrice = data.item_price {
               let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
               priceLabel.text =  currencySymbol + itemPrice
               priceLabel.textColor = UIColor.black
           } else {
               priceLabel.text =  "NA"
               priceLabel.textColor = UIColor.red
           }
           
           if let strMeasureQuantity = Constants.getMeasure(itemCode: data.item_code) {
               if strMeasureQuantity == "0" || strMeasureQuantity == "0.00" || strMeasureQuantity == "0.0" || strMeasureQuantity == "" {
                   measureTextField.placeholder = "QTY"
               } else {
                   let floatQuantity = (strMeasureQuantity as NSString).floatValue.clean
                   let strQuantity = String(floatQuantity)
                   measureTextField.text  = strQuantity as String
               }
           } else {
               measureTextField.text = ""
           }
           
           if let strQuantity = Constants.getPrice(itemCode: data.item_code){
               // if (strQuantity == "0.00" || strQuantity == "0") {
               let Intprice = Int(strQuantity)
               if (Intprice == 0) {
                   if (data.special_item_id == 1) {
                       quantityTextField.text = ""
                   }
                   else {
                       if (data.uom?.count == 0) {
                           quantityTextField.text = "0"
                       }
                       else {
                           quantityTextField.text = ""
                       }
                   }
               } else {
                   let floatQuantity = (strQuantity as NSString).floatValue.clean
                   let strQuantity = String(floatQuantity)
                   quantityTextField.text  = strQuantity as String
               }
           } else {
               quantityTextField.text = ""
           }
           
           if let specialItemID = data.special_item_id {
               if (specialItemID == 1) {
                   priceLabel.textColor = AppColors.redTextColor
                   if let strQuantity = data.quantity {
                      
                       if (strQuantity == "0.00" || strQuantity == "0") {
                           favouriteButton.isHidden = false
                           favoriteViewWidthConstraints.constant = 18
                           addButtonContainerVIew.isHidden = true
                       } else {
                           favouriteButton.isHidden = true
                           favoriteViewWidthConstraints.constant = 18
                           addButtonContainerVIew.isHidden = false
                       }
                   }
               }
               else {
                   priceLabel.textColor = UIColor.black
                   favouriteButton.isHidden = true
                   favoriteViewWidthConstraints.constant = 18
                   addButtonContainerVIew.isHidden = false
               }
           } else {
               priceLabel.textColor = UIColor.black
               favouriteButton.isHidden = true
               favoriteViewWidthConstraints.constant = 18
               addButtonContainerVIew.isHidden = false
           }
           
          
           
           
           
           if let status = data.status {
               
               if(status != "Active") {
                   quantityTextField.isHidden = true
                   inactiveLabel.isHidden = false
                   inactiveLabel.text = "NA"
                   priceLabel.isHidden  = true
                   //specialItemLabel.isHidden = true
                   productNameLabel.isHidden = false
                   measureTextField.isHidden = true
                   addChipsView.isHidden = true
                   crossImageView.isHidden = true
                //   stackView.isHidden = true
                   //addChipsLeadingWidthConstraint.constant = 22
               } else {
                   quantityTextField.layer.borderWidth = 0.5;
                   quantityTextField.layer.cornerRadius = 5;
                   quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
                   quantityTextField.textColor = UIColor.black
                   if let specialItemID = data.special_item_id {
                       if (specialItemID == 1) {
                           //cell.specialItemLabel.isHidden = true
                           quantityTextField.isHidden = false
                           priceLabel.isHidden = false
                           productNameLabel.isHidden = false
                           quantityTextField.isEnabled = true
                       }
                       else {
                           //cell.specialItemLabel.isHidden = true
                           quantityTextField.isHidden = false
                           quantityTextField.isEnabled = true
                           priceLabel.isHidden = false
                           productNameLabel.isHidden = false
                       }
                   }
               }
           }
           else {
               quantityTextField.isHidden = true
               inactiveLabel.isHidden = false
               inactiveLabel.text = "NA"
               //priceLabel.isHidden  = true
               priceLabel.text = ""
               //cell.specialItemLabel.isHidden = true
               productNameLabel.isHidden = true
           }
           
           if(showPrice == "0") {
               if let specialItemID = data.special_item_id {
                   if( specialItemID == 1){
                       priceLabel.textColor = AppColors.redTextColor
                       priceLabel.isHidden = false
                   } else {
                       //                    priceLabel.isHidden = true
                       priceLabel.text = ""
                       priceLabel.textColor = UIColor.black
                   }
               }
           } else {
               if let specialItemID = data.special_item_id {
                   if( specialItemID == 1) {
                       priceLabel.textColor = AppColors.redTextColor
                       if let status = data.status {
                           if(status != "Active") {
                               //                            priceLabel.isHidden = true
                               priceLabel.text = ""
                           } else {
                               priceLabel.isHidden = false
                           }
                       }
                   } else {
                       priceLabel.textColor = UIColor.black
                       if let status = data.status {
                           if(status != "Active") {
                               //                            priceLabel.isHidden = true
                               priceLabel.text = ""
                           } else {
                               priceLabel.isHidden = false
                           }
                       }
                   }
               }
           }
           
           if let specialTitle = data.special_title {
               if let specialId = data.special_item_id {
                   if(specialTitle == 1) || (specialId == 1) {
                       //viewModel.specialItemIndex = indexPath.row
                       //specialItemLabel.text = viewModel.arrItemsData[indexPath.row].item_name
                       //cell.specialItemLabel.isHidden = false
                       //productNameLabel.isHidden = true
                       //quantityTextField.isHidden = true
                       //priceLabel.isHidden = true
                       favouriteButton.isHidden  = false
                       favoriteViewWidthConstraints.constant = 18
                       addButtonContainerVIew.isHidden = true
                   } else {
                       //productNameLabel.isHidden = false
                       // quantityTextField.isHidden = false
                       //priceLabel.isHidden = false
                       //favouriteButton.setImage(UIImage(named: "starFill"), for: .normal)
                       favouriteButton.isHidden  = true
                       favoriteViewWidthConstraints.constant = 18
                       addButtonContainerVIew.isHidden = false
                   }
               }
           }
           
           if displayAll {
               addButtonContainerVIew.isHidden = true
           } else {
               addButtonContainerVIew.isHidden = false
           }
       }
    
    //MARK: -> configure-Specials-Data
    func configureSpecialsData(data: GetItemsData, showImage: String, showPrice: String) {
        configureShowImage(isShow: showImage)
        addButtonContainerVIew.isHidden = true
        quantityTextField.isHidden = false
        inactiveLabel.isHidden = true
        inactiveLabel.text = ""
        //quantityTextField.font = UIFont.OpenSans(.semibold, size: 13)
        inactiveLabel.textColor = UIColor.red
        //        cell.didChangeQuantity = { value in
        //            let itemCode = self.viewModel.arrItemsData[indexPath.row].item_code ?? ""
        //            if(value == "") {
        //                self.updateQuantityInArray(quantity: "0", sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
        //
        //            } else  {
        //                self.updateQuantityInArray(quantity: value , sectionIndexPath: self.viewModel.indexPathCategory, rowIndexPath: indexPath,itemCode: itemCode,isReloadTableView: false)
        //            }
        //        }
        //        cell.btnShowItemData = {
        //            self.showItemData(row: indexPath.row)
        //        }
        //cell.quantityTextField.delegate = self
        quantityTextField.isEnabled  = true
        //cell.quantityTextField.tag = indexPath.row
        
        if let strUOM = data.uom {
            quantityTextField.attributedPlaceholder = NSAttributedString(string: strUOM,
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
           
        }
        
        if let showUnit = data.is_meas_box {
            if showUnit == 1 {
                measureTextField.isHidden = false
                addChipsView.isHidden = false
                showListView.isHidden = false
                crossImageView.isHidden = false
                measureTextFieldWidthConstraints.constant = 50
                crossImageWidthConstraints.constant = 22
                textFieldContainerViewWidthConstraints.constant = 122
            } else {
                measureTextField.isHidden = true
                addChipsView.isHidden = true
                showListView.isHidden = true
                crossImageView.isHidden = true
                measureTextFieldWidthConstraints.constant = 0
                crossImageWidthConstraints.constant = 0
                textFieldContainerViewWidthConstraints.constant = 60
            }
        }
        
        if let itemName = data.item_name {
            if(itemName != "")
            {
                productNameLabel.text = itemName
            }
        }
//
//        if let image = data.image {
//            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
//        } else {
//            productImageView.image = Icons.placeholderImage
//        }
        
        if let thumb_image = data.thumb_image {
            productImageView.sd_setImage(with: URL(string: thumb_image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else if let image = data.image {
            productImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .highPriority, context: nil)
        } else {
            productImageView.image = Icons.placeholderImage
        }
        
        if let itemPrice = data.item_price {
            let currencySymbol = UserDefaults.standard.object(forKey:UserDefaultsKeys.CurrencySymbol) as? String ?? ""
            priceLabel.text =  currencySymbol + String(itemPrice)
        }
        
        //        if let strQuantity = data.quantity {
        //            if (strQuantity == "0.00" || strQuantity == "0") {
        //                if (data.special_title == 1)
        //                {
        //                    quantityTextField.text = "";
        //                }
        //                else
        //                {
        //                    if (data.uom?.count == 0)
        //                    {
        //                        quantityTextField.text = "0";
        //                    }
        //                    else
        //                    {
        //                        quantityTextField.text = "";
        //                    }
        //                }
        //            } else {
        //
        //                let floatQuantity = (strQuantity as NSString).floatValue.clean
        //                let strQuantity = String(floatQuantity)
        //                quantityTextField.text  = strQuantity as String
        //            }
        //        }
        
        if let strQuantity = Constants.getPrice(itemCode: data.item_code) {
            let Intprice = Int(strQuantity)
            if (Intprice == 0) {
                if (data.special_title == 1) {
                    quantityTextField.text = "";
                }
                else {
                    if (data.uom?.count == 0) {
                        quantityTextField.text = "0";
                    }
                    else {
                        quantityTextField.text = "";
                    }
                }
            } else {
                let floatQuantity = (strQuantity as NSString).floatValue.clean
                let strQuantity = String(floatQuantity)
                quantityTextField.text  = strQuantity as String
            }
        } else {
            quantityTextField.text = ""
        }
        
        if let specialItemID = data.special_item_id {
            if ( specialItemID == 1) {
                if let strQuantity = data.quantity {
                    if (strQuantity == "0.00" || strQuantity == "0") {
                        favouriteButton.isHidden = false
                        favoriteViewWidthConstraints.constant = 18
                    }
                } else {
                    favouriteButton.isHidden = true
                    favoriteViewWidthConstraints.constant = 18
                }
            }
            else {
                favouriteButton.isHidden = true
                favoriteViewWidthConstraints.constant = 18
            }
        }
        
        if let status = data.status {
            if(status != "Active") {
                inactiveLabel.text = "NA"
                inactiveLabel.isHidden = false
                quantityTextField.isHidden = true
                //                priceLabel.isHidden  = true
                priceLabel.text = ""
                //specialIItemLabel.isHidden = true
                productNameLabel.isHidden = false
            } else {
                quantityTextField.layer.borderWidth = 0.5;
                quantityTextField.layer.cornerRadius = 5;
                quantityTextField.layer.borderColor = UIColor.lightGray.cgColor;
                quantityTextField.textColor = UIColor.black
                if let specialItemID = data.special_item_id {
                    if (specialItemID == 1) {
                        //specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                        quantityTextField.isEnabled = true
                    }
                    else {
                        //cell.specialIItemLabel.isHidden = true
                        quantityTextField.isHidden = false
                        quantityTextField.isEnabled = true
                        priceLabel.isHidden = false
                        productNameLabel.isHidden = false
                    }
                }
            }
        }
        else {
            inactiveLabel.text = "NA"
            inactiveLabel.isHidden = false
            quantityTextField.isHidden = true
            //            priceLabel.isHidden  = true
            priceLabel.text = ""
            //cell.specialIItemLabel.isHidden = true
            productNameLabel.isHidden = true
        }
        
        if(showPrice == "0") {
            if let specialItemID = data.special_item_id {
                if( specialItemID == 1){
                    priceLabel.textColor = AppColors.redTextColor
                    priceLabel.isHidden = false
                } else {
                    priceLabel.textColor = AppColors.redTextColor
                    //                    priceLabel.isHidden = true
                    priceLabel.text = ""
                }
            }
        } else {
            if let specialItemID = data.special_item_id {
                if( specialItemID == 1){
                    priceLabel.textColor = AppColors.redTextColor
                    if let status = data.status {
                        if(status != "Active") {
                            //priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                } else {
                    priceLabel.textColor = AppColors.redTextColor
                    if let status = data.status {
                        if(status != "Active") {
                            //priceLabel.isHidden = true
                            priceLabel.text = ""
                        } else {
                            priceLabel.isHidden = false
                        }
                    }
                }
            }
        }
        
        if let specialTitle = data.special_title {
            if(specialTitle == 1) {
                //viewModel.specialItemIndex = indexPath.row
                //cell.specialIItemLabel.text = viewModel.arrItemsData[indexPath.row].item_name
                // cell.specialIItemLabel.isHidden = false
                productNameLabel.isHidden = true
                quantityTextField.isHidden = true
                //                priceLabel.isHidden = true
                priceLabel.text = ""
                //favouriteButton.isHidden  = true
                //productImageView.isHidden = true
            }
        }
    }
    
    //MARK: -> Button Actions
    
    
    @IBAction func showListAction(_ sender: Any) {
        didClickShowList?()
    }
    
    @IBAction func addItemToCartAction(_ sender: Any) {
        didClickAddItemToCart?()
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        didClickAdd?()
    }
    
    @IBAction func favouriteButton(_ sender: UIButton) {
    }
    
    @IBAction func didChangeQuantity(_ sender: UITextField) {
        qauntity?(sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
       // didChangeText?()
    }
    
    @IBAction func productImageButton(_ sender: UIButton) {
        didClickProduct?()
    }
    
}

//MARK: -> UITextFieldDelegate
extension SpecialProductsCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == quantityTextField {
            measureTextField.becomeFirstResponder()
        } else {
            measureTextField.resignFirstResponder()
        }
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let delegeteMyListSuccess = delegeteMyListSuccess {
            //delegeteMyListSuccess.isSuceess(success: true, text: text, index: textField.tag, measureQty: "")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        print("TextField did end editing method called\(textField.text!)")
        //        _ = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        //        if measureTextField.text != "" {
        //            if let delegeteMyListSuccess = delegeteMyListSuccess {
        //                delegeteMyListSuccess.isSuceess(success: true, text: quantityTextField.text ?? "0", index: textField.tag, measureQty: measureTextField.text ?? "1")
        //            }
        //        } else {
        //            if let delegeteMyListSuccess = delegeteMyListSuccess {
        //                delegeteMyListSuccess.isSuceess(success: true, text: quantityTextField.text ?? "0", index: textField.tag, measureQty: "1")
        //            }
        //        }
        
        //        if self.is_meas_box == 1 {
        //            if let cell = getCell(for: textField) {
        //                if let measureTextField = cell.measureTextField.text, let quantityTextField = cell.quantityTextField.text {
        //                    if quantityTextField != "" && measureTextField != "" && quantityTextField != "0" && quantityTextField != "0.0" && quantityTextField != "0.00" && measureTextField != "0" && measureTextField != "0.0" && measureTextField != "0.00" {
        //                        if let delegeteMyListSuccess = delegeteMyListSuccess {
        //                            delegeteMyListSuccess.isSuceess(success: true, text:  quantityTextField, index: textField.tag, measureQty: measureTextField)
        //                        }
        //                    } else {
        //                        if (quantityTextField == "" && measureTextField == "" ) || (quantityTextField == "0" && measureTextField == "0"){
        //                            if let delegeteMyListSuccess = delegeteMyListSuccess {
        //                                delegeteMyListSuccess.isSuceess(success: true, text: "0", index: textField.tag, measureQty: "0")
        //                            }
        //                        }
        //                    }
        //                } else {
        //                   
        //                }
        //            } else {
        //                print("not found")
        //            }
        //        } else {
        //            if let cell = getCell(for: textField) {
        //                if let quantityTextField = cell.quantityTextField.text {
        //                    if quantityTextField != ""  {
        //                        if let delegeteMyListSuccess = delegeteMyListSuccess {
        //                            delegeteMyListSuccess.isSuceess(success: true, text: quantityTextField, index: textField.tag, measureQty: "1")
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    }
        
        
        if let cell = getCell(for: textField) {
            if cell.measureTextField.isHidden != true {
                if let measureTextField = cell.measureTextField.text, let quantityTextField = cell.quantityTextField.text {
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
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        // get the current text, or use an empty string if that failed
    //        let currentText = textField.text ?? ""
    //        // attempt to read the range they are trying to change, or exit if we can't
    //        guard let stringRange = Range(range, in: currentText) else { return false }
    //        // add their new text to the existing text
    //        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    //        // make sure the result is under 16 characters
    //        return updatedText.count <= 4
    //    }
    
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
    
    func getCell(for textField: UITextField) -> SpecialProductsCollectionViewCell? {
        var view: UIView? = textField
        while let superview = view?.superview {
            if let cell = superview as? SpecialProductsCollectionViewCell {
                return cell
            }
            view = superview
        }
        return nil
    }
    
    
//    func getCell(for textField: UITextField, in collectionView: UICollectionView) -> SpecialProductsCollectionViewCell? {
//        let point = collectionView.convert(textField.bounds.origin, from: textField)
//        if let indexPath = collectionView.indexPathForItem(at: point) {
//            return collectionView.cellForItem(at: indexPath) as? SpecialProductsCollectionViewCell
//        }
//        return nil
//    }
}
