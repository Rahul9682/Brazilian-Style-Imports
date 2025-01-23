//  GetProfileModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/17/21.

import Foundation

struct GetProfileModel: Codable {
    
    var status: Int?
    var message: String?
    var data: GetProfileData?
    
    enum codingKeys: String, CodingKey{
        
        case status = "status"
        case message = "message"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(GetProfileData.self,forKey: .data))
    }
}

struct GetProfileData: Codable {
    
    var user_code: String?
    var email: String?
    var business_name: String?
    var first_name: String?
    var last_name: String?
    var contact_name: String?
    var phone: String?
    var mobile: String?
    var delivery_note:String?
    var delivery_address: String?
    var delivery_suburb: String?
    var delivery_post_code: String?
    var delivery_state: String?
    var delivery_country: String?
    var postal_address: String?
    var postal_suburb: String?
    var postal_post_code: String?
    var postal_state: String?
    var postal_country: String?
    var show_price: String?
    var customer_type: String?
    var show_delivery: Int?
    var outlets: Int?

    enum codingKeys: String, CodingKey{
        case user_code = "user_code"
        case email = "email"
        case business_name = "business_name"
        case first_name = "first_name"
        case last_name = "last_name"
        case contact_name = "contact_name"
        case phone = "phone"
        case mobile = "mobile"
        case delivery_address = "delivery_address"
        case delivery_suburb = "delivery_suburb"
        case delivery_post_code = "delivery_post_code"
        case delivery_state = "delivery_state"
        case delivery_country = "delivery_country"
        case postal_address = "postal_address"
        case postal_suburb = "postal_suburb"
        case postal_post_code = "postal_post_code"
        case postal_state = "postal_state"
        case postal_country = "postal_country"
        case show_price = "show_price"
        case show_delivery = "show_delivery"
        case outlets = "outlets"
        case delivery_note = "delivery_note"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        
        user_code = try? (values.decodeIfPresent(String.self,forKey: .user_code))
        email = try? (values.decodeIfPresent(String.self,forKey: .email))
        business_name = try? (values.decodeIfPresent(String.self,forKey: .business_name))
        first_name = try? (values.decodeIfPresent(String.self,forKey: .first_name))
        last_name = try? (values.decodeIfPresent(String.self,forKey: .last_name))
        contact_name = try? (values.decodeIfPresent(String.self,forKey: .contact_name))
        phone = try? (values.decodeIfPresent(String.self,forKey: .phone))
        mobile = try? (values.decodeIfPresent(String.self,forKey: .mobile))
        delivery_address = try? (values.decodeIfPresent(String.self,forKey: .delivery_address))
        delivery_suburb = try? (values.decodeIfPresent(String.self,forKey: .delivery_suburb))
        delivery_post_code = try? (values.decodeIfPresent(String.self,forKey: .delivery_post_code))
        delivery_state = try? (values.decodeIfPresent(String.self,forKey: .delivery_state))
        delivery_country = try? (values.decodeIfPresent(String.self,forKey: .delivery_country))
        postal_address = try? (values.decodeIfPresent(String.self,forKey: .postal_address))
        postal_suburb = try? (values.decodeIfPresent(String.self,forKey: .postal_suburb))
        postal_post_code = try? (values.decodeIfPresent(String.self,forKey: .postal_post_code))
        postal_state = try? (values.decodeIfPresent(String.self,forKey: .postal_state))
        postal_country = try? (values.decodeIfPresent(String.self,forKey: .postal_country))
        show_price = try? (values.decodeIfPresent(String.self,forKey: .show_price))
        show_delivery = try? (values.decodeIfPresent(Int.self,forKey: .show_price))
        outlets = try? (values.decodeIfPresent(Int.self,forKey: .outlets))
        delivery_note = try? (values.decodeIfPresent(String.self,forKey: .delivery_note))
    
    }
}
