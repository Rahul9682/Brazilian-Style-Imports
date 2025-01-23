//
//  ToastViewController.swift
//  Ezyfresh
//
//  Created by Braintech on 20/03/24.
//

import UIKit

class ToastViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - properties
    var message = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        messageLabel.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.dismiss(animated: false)
        }
    }
    // MARK: - Helpers
    func configureUI() {
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
    }
}
