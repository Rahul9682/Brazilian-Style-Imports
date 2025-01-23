//  UIViewControllerExtensions.swift
//  Luxury Car
//  Created by Sazid Saifi on 20/05/22.

import Foundation
import UIKit

extension UIViewController {
    
    func showToast(message: String?, toastType: ToastType) {
        if let message = message {
            DispatchQueue.main.async {
                self.MotionToast(message: message, toastType: toastType, duration: .short, toastStyle: .style_vibrant, toastGravity: .centre,toastCornerRadius: 10)
            }
        }
    }
}
