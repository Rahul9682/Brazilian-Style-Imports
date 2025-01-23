//  BackgroundView.swift
//  Luxury Car
//  Created by braintech on 02/05/22.

import UIKit

class BackgroundView: UIView {

    //MARK: -> OutLets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    //MARK: -> Properties
    var didClickRefreshButton: (() -> Void)?
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: -> Button Action
    @IBAction func refreshButton(_ sender: UIButton) {
        didClickRefreshButton?()
    }
    
    //MARK: -> Helpers
    func configureUI() {
        refreshButton?.layer.cornerRadius = 4
        refreshButton?.layer.masksToBounds = true
    }
    
    func configureUI(with backgroundImageName: UIImage?, message: String) {
        backgroundImageView.image = backgroundImageName
        messageLabel.text = message
       // refreshButton.backgroundColor = UIColor.green
        refreshButton.setTitleColor(UIColor.white, for: .normal)
        refreshButton.backgroundColor = UIColor.init(red: 40/255, green: 152/255, blue: 161/255, alpha: 1)
        refreshButton.setTitle("Refresh", for: .normal)
    }
    
}
