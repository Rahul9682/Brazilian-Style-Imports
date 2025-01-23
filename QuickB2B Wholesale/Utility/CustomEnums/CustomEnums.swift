//  CustomEnums.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation

enum TabType {
    case home, myList, myProduct, special, account, myOrders ,none
}

enum SelectDeliveryType {
    case Business
    case HomeDelivery
}

enum ProductListingType {
    case none
    case searchByCategory
    case specials
    case proudctList
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}
