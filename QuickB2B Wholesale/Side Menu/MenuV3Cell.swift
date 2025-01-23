//  Created by mac5 on 01/08/17.
//  Copyright © 2017 Braintechnosys pvt ltd. All rights reserved.

import UIKit

class MenuV3Cell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: SemiBoldLabelSize14!
    @IBOutlet var logoutButton: UIButton!
    
    // MARK: - Properties
    var didClickLogoutButton: (() -> Void)?
    
    //MARK: - LifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Helpers
    func configureUI(with item: [String: Any],with section:Int, index: Int) {
        itemImage.contentMode = .center
        guard let name = item["name"] as? String else { return }
        guard let imageName = item["image"] as? String else { return }
        
        itemName.text = name
        itemImage.image = UIImage(named: imageName)
        containerView.backgroundColor = UIColor.init(red: 212.0/255, green: 235.0/255, blue: 242.0/255, alpha: 0.8)
    }
    
    func configureHeader(with title: String) {
        itemImage.contentMode = .center
        itemName.text = title
        itemImage.image = UIImage(named: "greenArrow")
    }
    
    //MARK: - ACTIONS
    
    @IBAction func logoutButton(_ sender: UIButton) {
        didClickLogoutButton?()
    }
}
