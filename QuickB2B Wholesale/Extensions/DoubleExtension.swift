//  DoubleExtension.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 05/06/23.

import Foundation

extension Double {
    var decimalPlaces: Int {
        let decimals = String(self).split(separator: ".")[1]
        return decimals == "0" ? 0 : decimals.count
    }
}

