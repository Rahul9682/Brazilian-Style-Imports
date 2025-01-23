//  ShowItemDataViewController.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/31/21.

import UIKit

class ShowItemDataViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var mainViewHeightConst: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var productCodeLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imgViewHeightConst: NSLayoutConstraint!
    
    //MARK: -> Properies
    var viewModel = ShowItemDataViewModel()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureViewWillAppear()
    }
    
    //MARK: - Helpers
    private func configureUI() {
        mainView.layer.cornerRadius = 20
        mainView.layer.borderWidth = 1
        mainView.layer.masksToBounds = true
        itemImageView.layer.borderWidth = 1
        itemImageView.layer.borderWidth = 1
        itemImageView.layer.borderColor = UIColor.darkGray.cgColor
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 1.0
        mainView.layer.shadowRadius = 1.5
        mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        closeButton.layer.borderWidth = 0.5
        closeButton.layer.cornerRadius = self.closeButton.frame.size.height/2
        closeButton.layer.masksToBounds = true
        let strProduct = "Product Code:"
        mainViewHeightConst.constant = CGFloat(Float(calculateHeight(viewModel.itemName, itemCode: "\(strProduct)\(self.viewModel.itemCode)", descripton: viewModel.itemDescription)))
    }
    
    private func configureViewWillAppear() {
        self.itemNameLabel.text = viewModel.itemName
        self.productCodeLabel.text = "Product Code:"+viewModel.itemCode
        self.descriptionLabel.text = self.viewModel.itemDescription
        if(viewModel.imgUrl == "") {
            itemImageView.isHidden = true
            imgViewHeightConst.constant = 0
            mainViewHeightConst.constant = 223
        } else {
            itemImageView.isHidden = false
            imgViewHeightConst.constant = 150
            mainViewHeightConst.constant = 373
        }
        
        if let url = viewModel.imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            viewModel.imgUrl = url
            if let url = URL(string: viewModel.imgUrl) {
                /// itemImageView?.kf.setImage(with: url)
                itemImageView?.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
    
    //MARK: - METHOD TO CALCULATE HEIGHT
    func calculateHeight(_ title: String?, itemCode code: String?, descripton desc: String?) -> Float {
        let heightForTitle = getHeightForText(title, with: UIFont.systemFont(ofSize: 15.0), andWidth: 276.0)
        let heightForItemCode = getHeightForText(code, with: UIFont.systemFont(ofSize: 13.0), andWidth: 276.0)
        let heightForDescription = getHeightForText(desc, with: UIFont.systemFont(ofSize: 13.0), andWidth: 276.0)
        let heightTotal = heightForTitle + heightForItemCode + heightForDescription + 220
        let estimatedHeightForMainView = Float(self.view.frame.size.height - 32)
        if(heightTotal >= estimatedHeightForMainView) {
            return (estimatedHeightForMainView)
        } else {
            return heightTotal
        }
    }
    
    func getHeightForText(_ text: String?, with font: UIFont?, andWidth width: Float) -> Float {
        let constraint = CGSize(width: CGFloat(width), height: 20000.0)
        var title_size: CGSize!
        var totalHeight: CGFloat
        if let font = font {
            title_size = text?.boundingRect(
                with: constraint,
                options: .usesLineFragmentOrigin,
                attributes: [
                    NSAttributedString.Key.font: font
                ],
                context: nil).size ?? CGSize.zero
        }
        totalHeight = ceil(title_size.height)
        let height = CGFloat(max(totalHeight, 40.0))
        return Float(height)
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK: - ScrollView Delegates
extension ShowItemDataViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
}
