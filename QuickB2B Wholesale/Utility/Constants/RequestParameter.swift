//  RequestParameter.swift
//  Purpose
//  Created by Brain Tech on 12/27/19.
//  Copyright © 2019 Brain Tech. All rights reserved.

import Foundation

// MARK: - Sign up Params
enum SignUp : String {
    case first_name = "first_name"
    case lastName = "last_name"
    case email = "email"
    case dial_code = "dial_code"
    case country_code = "country_code"
    case country_id = "country_id"
    case mobile = "mobile"
    case password = "password"
    case passwordConformation = "password_confirmation"
}

// MARK: - Supplier Id Params
enum SupplierID : String {
    case type = "type"
    case client_code = "client_code"
    case app_type = "app_type"
}

// MARK: - Otp up Params
enum Otp : String {
    case email = "email"
    case otp = "otp"
}

// MARK: - Login up Param
enum login : String {
    case type = "type"
    case client_code = "client_code"
    case app_type = "app_type"
    case username = "username"
    case password = "password"
    case device_id = "device_id"
    case user_code = "user_code"
    case device_model = "device_model"
    case device_ip_address = "device_ip_address"
    
}

// MARK: - GetAppData Param
enum GetAppData : String {
    case type = "type"
    case client_code = "client_code"
    case app_type = "app_type"
    case device_id = "device_id"
}

// MARK: - UpdateProductList Param
enum UpdateProductList : String {
    case type = "type"
    case client_code = "client_code"
    case app_type = "app_type"
    case user_code = "user_code"
    case orderFlag = "orderFlag"
    case cartItems = "cartItems"
    case multiItems = "multiItems"
    case device_id = "device_id"
    case acm_code = "acm_code"
    case device_type = "device_type"
}

// MARK: - UpdateProductList Param
enum ProductDetailsParam : String {
    case client_code = "client_code"
    case user_code = "user_code"
    case device_id = "device_id"
    case itemCode = "itemCode"
}

// MARK: - GetPushNotification Param
enum GetPushNotification : String {
    case type = "type"
    case client_code = "client_code"
    case app_type = "app_type"
    case user_code = "user_code"
    case device_id = "device_id"
    case device_type = "device_type"
    case device_token = "device_token"
    case device_model = "device_model"
    case device_ip_address = "device_ip_address"
}

// MARK: - GetCategories Param
enum GetCategoryData : String {
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case device_id = "device_id"
}

// MARK: - GetItemsByCategory Param
enum GetItemsByCategoryData : String {
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case app_type = "app_type"
    case category_id = "category_id"
    case device_id = "device_id"
}

// MARK: - GetItemsByCategory Param
enum AddProduct : String {
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case app_type = "app_type"
    case item_code = "item_code"
    case device_id = "device_id"
}

// MARK: - SearchProductDetails Param
enum SearchProductDetails : String {
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case app_type = "app_type"
    case search = "search"
    case page = "page"
    case device_id = "device_id"
}

// MARK: - GetProfile Param
enum GetProfile : String {
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case app_type = "app_type"
    case device_id = "device_id"
}

// MARK: - GetFeaturedImage Param
enum GetFeaturedImage : String {
    case client_code = "client_code"
    case user_code = "user_code"
    case device_id = "device_id"
}

// MARK: - FetchUserOrder Param
enum FetchUserOrder : String {
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case app_type = "app_type"
    case device_id = "device_id"
  }

// MARK: - GetOrderDetails Param
enum GetOrderDetails : String {
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case app_type = "app_type"
    case order_id = "order_id"
    case device_id = "device_id"
  }

// MARK: - EditProfileDetails Param
enum EditProfileDetails : String {
    case mobile = "mobile"
    case phone = "phone"
    case business_name = "business_name"
    case user_code = "user_code"
    case last_name = "last_name"
    case email = "email"
    case app_type = "app_type"
    case type = "type"
    case delivery_note = "delivery_note"
    case client_code = "client_code"
    case first_name = "first_name"
    case device_id = "device_id"
}

// MARK: - EditBusinessDetails Param
enum EditBusinessDetails : String {
    case delivery_country = "delivery_country"
    case delivery_post_code = "delivery_post_code"
    case delivery_suburb = "delivery_suburb"
    case user_code = "user_code"
    case delivery_address = "delivery_address"
    case delivery_state = "delivery_state"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case device_id = "device_id"
}

// MARK: - EditPostalDetails Param
enum EditPostalDetails : String {
    case postal_country = "postal_country"
    case postal_post_code = "postal_post_code"
    case postal_suburb = "postal_suburb"
    case user_code = "user_code"
    case postal_address = "postal_address"
    case postal_state = "postal_state"
    case app_type = "app_type"
    case type = "type"
   case client_code = "client_code"
    case device_id = "device_id"
}

// MARK: - ChangePassword Param
enum ChangePasswordParam : String {
    case new_password = "new_password"
    case confirm_password = "confirm_password"
    case current_password = "current_password"
    case user_code = "user_code"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case device_id = "device_id"
}

// MARK: - ForgotPassword Param
enum ForgotPasswordParam : String {
    case username = "username"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case device_id = "device_id"
}

// MARK: - ConfirmPayment Param
enum ConfirmPaymentParam : String {
    case orderFlag = "orderFlag"
    case Cvc = "Cvc"
    case po_number = "po_number"
    case ExpiryYear = "ExpiryYear"
    case delivery_date = "delivery_date"
    case type = "type"
    case client_code = "client_code"
    case user_code = "user_code"
    case comment = "comment"
    case cartItems = "cartItems"
    case device_type = "device_type"
    case ExpiryMonth = "ExpiryMonth"
    case app_type = "app_type"
    case CardHolderName = "CardHolderName"
    case CardNumber = "CardNumber"
    case delivery_type = "delivery_type"
    case device_id = "device_id"
    case deliveryDateByPass = "deliveryDateByPass"
    case acm_code = "acm_code"
}

// MARK: - GetInformation Param
enum GetInformation : String {
    case user_code = "user_code"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case device_id = "device_id"
}

// MARK: - GetUserItems Param
enum GetUserItems : String {
    case user_code = "user_code"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case reset = "reset"
    case device_id = "device_id"
    case category_id = "category_id"
    case search = "search"
    case page = "page"
    case acm_code = "acm_code"
}


// MARK: - DeleteItems Param
enum DeleteItems : String {
    case user_code = "user_code"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case item_code = "item_code"
    case device_id = "device_id"
    case acm_code = "acm_code"
}

// MARK: - GetOutletList Param
enum GetOutletList : String {
    case user_code = "user_code"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case device_id = "device_id"
    case acm_code = "acm_code"
}

// MARK: - FetchLinks Param
enum FetchLinks : String {
    case user_code = "user_code"
    case app_type = "app_type"
    case type = "type"
    case client_code = "client_code"
    case device_id = "device_id"
    case acm_code = "acm_code"
}

//MARK: - SIGNUP PARAM
enum Signup : String {
    case type = "type"
    case client_code = "client_code"
    case business_name = "business_name"
    case email = "email"
    case customer_code = "customer_code"
    case first_name = "first_name"
    case last_name = "last_name"
    case phone = "phone"
    case mobile = "mobile"
    case delivery_address = "delivery_address"
    case delivery_suburb = "delivery_suburb"
    case delivery_post_code = "delivery_post_code"
    case delivery_state = "delivery_state"
    case delivery_country = "delivery_country"
    case password = "password"
    case delivery_note = "delivery_note"
    case postal_address = "postal_address"
    case postal_suburb = "postal_suburb"
    case postal_post_code = "postal_post_code"
    case postal_state = "postal_state"
    case postal_country = "postal_country"
    case device_type = "device_type"
    case app_type = "app_type"
    case device_id = "device_id"
    case acm_code = "rep_name"
}


//MARK: - GetAppDetails PARAM
enum AppDetailsGeneric : String {
    case type = "type"
    case client_code = "client_code"
    case app_type = "app_type"
    case device_id = "device_id"
    case acm_code = "acm_code"
}



//****************///////
// MARK: - Home - Param
enum homeParam : String {
    case user_code = "user_code"
    case client_code = "client_code"
    case device_id = "device_id"
    case acm_code = "acm_code"
   
    
}



enum addProductParam : String {
    case user_code = "user_code"
    case client_code = "client_code"
    case item_code = "item_code"
    case device_id = "device_id"
    case acm_code = "acm_code"
}

//MARK: - DELETE ACCOUNT PARAM
enum DeleteParam : String {
    case clientCode = "client_code"
    case deviceId = "device_id"
    case userCode = "user_code"
    case password = "password"
    case acm_code = "acm_code"
}

enum SaveCartParam : String {
    case user_code = "user_code"
    case client_code = "client_code"
    case device_id = "device_id"
}

// MARK: - ReOrder Param
enum ReOrder : String {
    case client_code = "client_code"
    case user_code = "user_code"
    case orderId = "orderId"
    case device_id = "device_id"
  }

