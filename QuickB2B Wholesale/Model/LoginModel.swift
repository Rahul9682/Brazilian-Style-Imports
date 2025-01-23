//  LoginModel.swift
//  QuickB2B Wholesale
// Created by Sazid Saifi on 07/06/23.

import Foundation

struct Login: Codable {
    
    var status: Int?
    var outlets: Int?
    var message: String?
    var data: LoginData?
    var login_type: String?
    
    enum codingKeys: String, CodingKey{
        
        case status = "status"
        case outlets = "outlets"
        case message = "message"
        case data = "data"
        case login_type = "login_type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        outlets = try? (values.decodeIfPresent(Int.self,forKey: .outlets))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        data = try? (values.decodeIfPresent(LoginData.self,forKey: .data))
        login_type = try? (values.decodeIfPresent(String.self,forKey: .login_type))
    }
}
struct LoginData: Codable {
    
    var user_code: String?
    var email: String?
    var business_name: String?
    var first_name: String?
    var last_name: String?
    var contact_name: String?
    var phone: String?
    var mobile: String?
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
    var APP_NAME: String?
    var APP_COMPANY_NAME: String?
    var name: String?
    var acm_code: String?

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
        case customer_type = "customer_type"
        case show_delivery = "show_delivery"
        case APP_NAME = "APP_NAME"
        case APP_COMPANY_NAME = "APP_COMPANY_NAME"
        case name = "name"
        case acm_code = "acm_code"
        
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
        customer_type = try? (values.decodeIfPresent(String.self,forKey: .customer_type))
        show_delivery = try? (values.decodeIfPresent(Int.self,forKey: .show_price))
        APP_NAME = try? (values.decodeIfPresent(String.self,forKey: .APP_NAME))
        APP_COMPANY_NAME = try? (values.decodeIfPresent(String.self,forKey: .APP_COMPANY_NAME))
        name = try? (values.decodeIfPresent(String.self,forKey: .name))
        acm_code = try? (values.decodeIfPresent(String.self,forKey: .acm_code))
    }
}

