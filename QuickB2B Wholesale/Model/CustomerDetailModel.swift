//
//  CustomerDetailModel.swift
//  QuickB2B
//
//  Created by Braintech on 25/10/24.
//

import Foundation

// MARK: - Welcome
struct CustomerDetailModel: Codable {
    var data: CustomerDetailsData?
    var status: Int?
    var outlets: Int?
}

// MARK: - DataClass
struct CustomerDetailsData: Codable {
    var appName, appCompanyName, userCode, email: String?
    var businessName, firstName, lastName, contactName: String?
    var phone, mobile, deliveryAddress, deliverySuburb: String?
    var deliveryPostCode, deliveryState, deliveryCountry, postalAddress: String?
    var postalSuburb, postalPostCode, postalState, postalCountry: String?
    var showPrice, customerType: String?
    var showDelivery: Int?

    enum CodingKeys: String, CodingKey {
        case appName = "APP_NAME"
        case appCompanyName = "APP_COMPANY_NAME"
        case userCode = "user_code"
        case email
        case businessName = "business_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case contactName = "contact_name"
        case phone, mobile
        case deliveryAddress = "delivery_address"
        case deliverySuburb = "delivery_suburb"
        case deliveryPostCode = "delivery_post_code"
        case deliveryState = "delivery_state"
        case deliveryCountry = "delivery_country"
        case postalAddress = "postal_address"
        case postalSuburb = "postal_suburb"
        case postalPostCode = "postal_post_code"
        case postalState = "postal_state"
        case postalCountry = "postal_country"
        case showPrice = "show_price"
        case customerType = "customer_type"
        case showDelivery = "show_delivery"
    }
}
