//  MyOrdersViewController.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import UIKit
import IQKeyboardManagerSwift
import IQTextView

class MyOrdersViewController: UIViewController {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var itemContainerView: UIView!
    @IBOutlet weak var deliveryDateContainerView: UIView!
    @IBOutlet weak var poNumberContainerView: UIView!
    @IBOutlet weak var commentsContainerVIew: UIView!
    @IBOutlet weak var commentsTextView: IQTextView!
    @IBOutlet weak var editOrderButton: UIButton!
    @IBOutlet weak var submitOrderButton: UIButton!
    
    //MARK: -> Properties
    var viewModel = MyOrdersviewModel()
    
    //MARK: -> LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCell()
    }
    
    //MARK: -> Helpers
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        itemContainerView.layer.cornerRadius = 8
        itemContainerView.layer.borderWidth = 0.5
        itemContainerView.layer.borderColor = UIColor.black.cgColor
        
        deliveryDateContainerView.layer.cornerRadius = 8
        deliveryDateContainerView.layer.borderWidth = 0.5
        deliveryDateContainerView.layer.borderColor = UIColor.black.cgColor
        
        poNumberContainerView.layer.cornerRadius = 8
        poNumberContainerView.layer.borderWidth = 0.5
        poNumberContainerView.layer.borderColor = UIColor.black.cgColor
        
        commentsContainerVIew.layer.cornerRadius = 8
        commentsContainerVIew.layer.borderWidth = 0.5
        commentsContainerVIew.layer.borderColor = UIColor.black.cgColor
        
        editOrderButton.layer.cornerRadius = 4
        editOrderButton.layer.borderWidth = 0.5
        editOrderButton.layer.borderColor = UIColor.black.cgColor
        
        submitOrderButton.layer.cornerRadius = 4
        submitOrderButton.layer.borderWidth = 0.5
        submitOrderButton.layer.borderColor = UIColor.black.cgColor
        
        viewModel.arrayOfOrderItems.append(ReviewOrderData(image: "vegetable", isImage: true, productName: "Good Quality Fresh Vegetable", price: "25.00", qty: "4.00"))
        viewModel.arrayOfOrderItems.append(ReviewOrderData(image: "juice", isImage: true, productName: "Good Quality Fresh Juice and soft Drinks", price: "788.00", qty: "10.00"))
        viewModel.arrayOfOrderItems.append(ReviewOrderData(image: "garlic", isImage: true, productName: "A herb growing from a strongly aromatic, rounded bulb composed", price: "80.00", qty: "45.00"))
        viewModel.arrayOfOrderItems.append(ReviewOrderData(image: "garlic", isImage: true, productName: "Coffee Beans- Colombian Reserve 1Kg", price: "80.00", qty: "45.00"))
        viewModel.arrayOfOrderItems.append(ReviewOrderData(image: "garlic", isImage: true, productName: "Mango - EACH", price: "8.00", qty: "97.95"))
        viewModel.arrayOfOrderItems.append(ReviewOrderData(image: "garlic", isImage: true, productName: "Avocado(24) - Order by Tray", price: "1.00", qty: "82.47"))
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: "ReviewOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewOrderTableViewCell")
    }
    
    //MARK: -> Button Actions
    @IBAction func editOrderButton(_ sender: UIButton) {
        
    }
    
    @IBAction func submitOrderButton(_ sender: UIButton) {
        
    }
}



//MARK: ->  UITableViewDelegate, UITableViewDataSource
extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfOrderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 //        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewOrderTableViewCell") as! ReviewOrderTableViewCell
//        cell.configureData(data: viewModel.arrayOfOrderItems[indexPath.row])
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
