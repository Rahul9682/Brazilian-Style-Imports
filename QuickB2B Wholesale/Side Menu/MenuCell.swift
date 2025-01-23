
//  Created by mac5 on 01/08/17.
//  Copyright © 2017 Braintechnosys pvt ltd. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: Helpers
    func configureUI(with item: [String: Any]) {
        
        guard let name = item["name"] as? String else { return }
        
        itemName.text = name
    }

}
