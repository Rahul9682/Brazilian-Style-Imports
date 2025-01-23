//  FloatExtension.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 05/06/23.

import Foundation

//MARK: - EXTENSION FOR CONVERTING STRING TO FLOAT
extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
