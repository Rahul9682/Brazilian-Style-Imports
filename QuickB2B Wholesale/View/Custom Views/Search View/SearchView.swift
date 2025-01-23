//
//  SearchView.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 19/04/23.
//

import UIKit

class SearchView: UIView {
    
    //MARK: -> Outlets
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: -> Properties
    var didSearchTextChange: ((String) ->Void)?
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: -> Helpers
    func configureUI(totalAmount: String) {
        searchContainerView.layer.cornerRadius =  6
        searchContainerView.layer.borderWidth = 0.5
        searchContainerView.layer.borderColor = UIColor.gray.cgColor
    }
    
    //MARK: -> Button Actions
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        let text = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        didSearchTextChange?(text)
    }
}
