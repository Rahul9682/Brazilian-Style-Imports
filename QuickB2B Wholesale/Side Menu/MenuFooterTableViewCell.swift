//
//  MenuFooterTableViewCell.swift
//  QuickB2B Wholesale
//
//  Created by Brain Tech on 23/01/2020 Saka.
//

import UIKit

class MenuFooterTableViewCell: UITableViewCell {

    var btnOpenUrl: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func openUrlButton(_ sender: Any) {
        btnOpenUrl?()
    }
    
}
