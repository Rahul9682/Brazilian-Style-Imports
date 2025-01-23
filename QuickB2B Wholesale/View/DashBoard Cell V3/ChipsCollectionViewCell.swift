//  ChipsCollectionViewCell.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 21/04/23.

import UIKit

class ChipsCollectionViewCell: UICollectionViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var underLineLabel: UILabel!
    @IBOutlet weak var rightSeparatorView: UIView!
    
    //MARK: -> Properties
    var underlineThickness: CGFloat = 1.0
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        chipsLabel.attributedText = nil
        //containerView.layer.cornerRadius = 16//containerView.frame.size.height / 2
        //containerView.layer.borderWidth = 0.5
        //containerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configureData(chipsData: CategoryData?) {
        if let chipsData = chipsData {
            chipsLabel.text = chipsData.name
            if chipsData.isSlected {
                chipsLabel.textColor = UIColor.black
                //underLineLabel.backgroundColor = UIColor.black
                addUnderLine(color: .black)
            } else {
                chipsLabel.textColor = UIColor.black
                addUnderLine(color: .clear)
                //underLineLabel.backgroundColor = UIColor.clear
            }
        }
    }
    
    func configureMyListData(chipsData: GetItemsWithCategoryData?) {
        if let chipsData = chipsData {
            chipsLabel.text = chipsData.category_title
            if chipsData.isSlected {
                chipsLabel.textColor = UIColor.black
               // underLineLabel.backgroundColor = UIColor.black
                addUnderLine(color: .black)
            } else {
                chipsLabel.textColor = UIColor.black
                addUnderLine(color: .clear)
                //underLineLabel.backgroundColor = UIColor.clear
                //chipsLabel.attributedText = nil
            }
        }
    }
    
    
    func configureAccountData(chipsData: AccountChipsData?) {
        if let chipsData = chipsData {
            chipsLabel.text = chipsData.name
            if chipsData.isSlected {
                chipsLabel.textColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
                ///underLineLabel.backgroundColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
//                addUnderLineWithColor()
                let underlineColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
                addUnderLine(color: underlineColor)
            } else {
                chipsLabel.textColor = UIColor.black
                addUnderLine(color: .clear)
                //underLineLabel.backgroundColor = UIColor.clear
            }
        }
    }
    
    
//    func addUnderLine() {
//        var attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
//        let attributedString = NSAttributedString(string: chipsLabel.text ?? "", attributes: attributes)
//        chipsLabel.attributedText = attributedString
//    }
    
    func addUnderLineWithColor() {
        var attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
           attributes[.underlineColor] = underlineColor
        let attributedString = NSAttributedString(string: chipsLabel.text ?? "", attributes: attributes)
        chipsLabel.attributedText = attributedString
    }
    
    //MARK: -> Button Actions
    func addUnderLine(color: UIColor) {
        let text = chipsLabel.text ?? ""
        let attributedString = NSMutableAttributedString(string: text)
        // Add an underline attribute with a custom offset
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        // Set the underline color
        let underlineColor = color // Change this to your desired color
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: underlineColor, range: NSRange(location: 0, length: text.count))
        // Adjust the baseline offset to provide space between text and underline
        let underlineOffset: CGFloat = 4.0 // Adjust this value as needed
        attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: underlineOffset, range: NSRange(location: 0, length: text.count))
        // Apply the attributed string to the label
        chipsLabel.attributedText = attributedString
    }
    
    func addWhiteUnderLine() {
        let text = chipsLabel.text ?? ""
        let attributedString = NSMutableAttributedString(string: text)
        // Add an underline attribute with a custom offset
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        // Set the underline color
        let underlineColor = UIColor.white // Change this to your desired color
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: underlineColor, range: NSRange(location: 0, length: text.count))
        // Adjust the baseline offset to provide space between text and underline
        let underlineOffset: CGFloat = 4.0 // Adjust this value as needed
        attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: underlineOffset, range: NSRange(location: 0, length: text.count))
        // Apply the attributed string to the label
        chipsLabel.attributedText = attributedString
    }
}

