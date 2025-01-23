//
//  ProductTableViewCell.swift
//  QuickB2BWholesale
//
//  Created by Sazid Saifi on 19/07/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: -> Properties
    var reloadDelegate:ReloadTableViewDelegate?
    var popUpDelegate: ShowListDelegate?
    var arrayOfSpecialItems = [GetItemsData]()
    var delegeteProductClick: DelegeteProductClick?
    var delegeteGetItemCode: DelegeteGetItemCode?
    var delegeteGetStringText: DelegeteGetStringText?
    var delegeteSuccessWithListType: DelegeteSuccessWithListType?
    var showPrice = ""
    var productType: ProductListingType = .proudctList
    var arrayOfAllInventoryItems = [GetItemsData]()
    var show_image = ""
    var index = 0
    var enteredQuantity: String = ""
    var enteredUnit: String?
    var editView = false
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        registerCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    func configureUI() {
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "SpecialProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpecialProductsCollectionViewCell")
    }
 
    func configureHomeProductListData(data: [GetItemsData], showImage: String, showPrice:String, listingType: ProductListingType) {
        self.productType = listingType
        self.showPrice = showPrice
        self.arrayOfAllInventoryItems = data
        self.show_image = showImage
        self.collectionView.reloadData()
    }
    
    //MARK: -> Button Actions
}


//MARK: -> UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrayOfAllInventoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialProductsCollectionViewCell", for: indexPath) as! SpecialProductsCollectionViewCell
        cell.configureUI()
        cell.quantityTextField.delegate = self
        cell.measureTextField.delegate = self
        cell.quantityTextField.tag = indexPath.row * 2 // Unique identifier for quantity
        cell.measureTextField.tag = indexPath.row * 2 + 1 // Unique identifier for unit
        cell.configureHomeProductListData(data: arrayOfAllInventoryItems[indexPath.row], showImage: self.show_image, showPrice: self.showPrice)
        cell.didClickAdd = { [weak self] in
            if let delegeteGetItemCode = self?.delegeteGetItemCode {
                if let itemCode = self?.arrayOfAllInventoryItems[indexPath.row].item_code {
                    delegeteGetItemCode.itemCode(itemCode: itemCode)
                }
            }
        }
//        cell.multiItemCount.text = "\(Constants.getCount(itemCode: arrayOfAllInventoryItems[indexPath.row].item_code ?? ""))"
        
        let count = Constants.getCount(itemCode: arrayOfAllInventoryItems[indexPath.row].item_code)
        if count != 0 {
            cell.multiItemCount.isHidden = false
            cell.multiItemCount.text = ("\(count)")
            
        } else {
            cell.multiItemCount.text = ""
            cell.multiItemCount.isHidden = true
        }
        
        cell.qauntity = { quantity in
            if let delegeteGetStringText = self.delegeteGetStringText {
                self.index = indexPath.row
                delegeteGetStringText.DelegeteGetStringText(quantity: quantity, index: indexPath.row, measure: "1.0")
            }
        }
        
        cell.didClickProduct = {
            if let delegeteProductClick = self.delegeteProductClick {
                delegeteProductClick.didClickProduct(index: indexPath.row, listingType: self.productType)
            }
        }
        
        print(cell.measureTextField.text)
        
        cell.didClickProductNameLabel = {
            print("Product NameLabel Click")
            if let delegeteProductClick = self.delegeteProductClick {
                delegeteProductClick.didClickProduct(index: indexPath.row, listingType: self.productType)
            }
        }
        
        cell.didClickShowList = {
            //UserDefaults.standard.removeObject(forKey: "ShowList")
            self.popUpDelegate?.didShowListTapDone(itemCode: self.arrayOfAllInventoryItems[indexPath.row].item_code ?? "")
        }
        
        cell.didClickAddItemToCart = {
            guard let origin = cell.quantityTextField.text else { return }
            guard let measure = cell.measureTextField.text else { return }
            let itemCode = self.arrayOfAllInventoryItems[indexPath.row].item_code
            let  selectedItem = self.arrayOfAllInventoryItems[indexPath.row]
            var mutatedItem = selectedItem
            if origin != "0" && origin != "0.0" && origin != "0.00" && measure != "0" && measure != "0.0" && measure != "0.00" && origin != "" && measure != "" {
                mutatedItem.priority = 0
                mutatedItem.id = 0
                mutatedItem.originQty = origin
                mutatedItem.measureQty = measure
                var data = LocalStorage.getShowItData()
                data.append(mutatedItem)
                LocalStorage.saveMultiData(data: data)
                LocalStorage.deleteGetItemsIndex(itemCode: itemCode ?? "")
                self.reloadDelegate?.reloadTableView()
            }
        }
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let delegeteProductClick = delegeteProductClick {
//            delegeteProductClick.didClickProduct(index: indexPath.row, listingType: self.productType)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if show_image == "1" {
            return CGSize(width: 182, height: 230)
        } else {
            return CGSize(width: 182, height: 154)
        }
    }
    
    //Spacing B/w Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

//MARK: -> UITextFieldDelegate
extension ProductTableViewCell: UITextFieldDelegate {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        collectionView.isScrollEnabled = false
        collectionView.alwaysBounceVertical = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        
        if let cell = getCell(for: textField) {
            if cell.measureTextField.isHidden != true {
                if let measureTextField = cell.measureTextField.text, let quantityTextField = cell.quantityTextField.text {
                    if quantityTextField != "" && measureTextField != "" && quantityTextField != "0" && quantityTextField != "0.0" && quantityTextField != "0.00" && measureTextField != "0" && measureTextField != "0.0" && measureTextField != "0.00" {
                        if let delegate = delegeteSuccessWithListType {
                            delegate.isSuccessWithListType(success: true, text: stringToFloat(userInput: quantityTextField), listType: self.productType, measureQty: measureTextField )
                            self.reloadDelegate?.reloadTableView()
                        }
                    } else {
                        if (quantityTextField == "" && measureTextField == "" ) || (quantityTextField == "0" && measureTextField == "0"){
                            if let delegate = delegeteSuccessWithListType {
                                delegate.isSuccessWithListType(success: true, text: "0", listType: self.productType, measureQty: "0" )
                                self.reloadDelegate?.reloadTableView()
                            }
                        }
                    }
                } else {
                    
                }
            } else {
                    if let quantityTextField = cell.quantityTextField.text {
                        if quantityTextField != ""  {
                            if let delegate = delegeteSuccessWithListType {
                                delegate.isSuccessWithListType(success: true, text: quantityTextField, listType: self.productType, measureQty: "1" )
                                self.reloadDelegate?.reloadTableView()
                            }
                        }  else {
                            if let delegate = delegeteSuccessWithListType {
                                delegate.isSuccessWithListType(success: true, text: "0", listType: self.productType, measureQty: "0" )
                                self.reloadDelegate?.reloadTableView()
                            }
                        }
                    }
            }
        } else {
            print("not found")
        }
        
        
        
//        print("TextField did end editing method called \(textField.text!)")
//        print(textField.tag)
//        collectionView.isScrollEnabled = true
//        collectionView.alwaysBounceVertical = true
//        print(self.index)
//        var changedUnit = ""
//        var changedqunatity = ""
//        
//        if textField.tag % 2 == 0 {
//            // quantityTextField logic
//            let enteredUnit = Constants.getMeasure(itemCode: self.productType == .proudctList ? self.arrayOfAllInventoryItems[self.index].item_code : self.arrayOfSpecialItems[self.index].item_code) ?? "1"
//            
//            let changedQuantity = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//            
//            let finalUnit = (enteredUnit.isEmpty || enteredUnit == "0" || enteredUnit == "0.00" || enteredUnit == "0.0") ? "1" : enteredUnit
//            
//            if let delegate = delegeteSuccessWithListType {
//                delegate.isSuccessWithListType(success: true, text: stringToFloat(userInput: changedQuantity), listType: self.productType, measureQty: finalUnit)
//            }
//            self.reloadDelegate?.reloadTableView()
//                        
//        } else {
//            // This is a unitTextField
//            let enteredQuantity = Constants.getQuantity(itemCode: self.productType == .proudctList ? self.arrayOfAllInventoryItems[self.index].item_code : self.arrayOfSpecialItems[self.index].item_code) ?? ""
//            let enteredUnit = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//            let finalUnit = (enteredUnit.isEmpty || enteredUnit == "0" || enteredUnit == "0.00" || enteredUnit == "0.0") ? "1" : enteredUnit
//            if let delegate = delegeteSuccessWithListType {
//                delegate.isSuccessWithListType(success: true, text: enteredQuantity, listType: self.productType, measureQty: stringToFloat(userInput: finalUnit))
//            }
//        }
//        self.editView = true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       return true
    }

    
    func stringToFloat(userInput: String) -> String {
        // Convert the string to a Double
        if let doubleValue = Double(userInput) {
            // Create and configure a NumberFormatter
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            // Convert the Double to a formatted string
            if let resultString = formatter.string(from: NSNumber(value: doubleValue)) {
                print("Formatted result: \(resultString)")
                return resultString
            } else {
                print("Error formatting the number")
                return ""
            }
           
        } else {
            // Handle the case where the string could not be converted to Double
            print("Invalid input: \(userInput) could not be converted to a Double")
            return ""
           
        }

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
    
    
}
