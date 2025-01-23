//
//  CustomerListModel.swift
//  QuickB2B
//
//  Created by Braintech on 24/10/24.
//

import Foundation


import Foundation

// MARK: - Welcome
struct CustomerListModel: Codable {
    let data: [CustomerDetails]?
    let status: Int?
    let message: String?
}

// MARK: - CustomerDetails
struct CustomerDetails: Codable {
    let customerCode: String?
    let email: String?
    let businessName: String?
    let firstName: String?
    let contactName: String?
    let lastName: String?
    let deliverySuburb: String?
    let isManager: Int?

    enum CodingKeys: String, CodingKey {
        case customerCode = "customer_code"
        case email
        case businessName = "business_name"
        case firstName = "first_name"
        case contactName = "contact_name"
        case lastName = "last_name"
        case deliverySuburb = "delivery_suburb"
        case isManager = "isManager"
    }
}

