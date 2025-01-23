//  GetUserItemsModel.swift
//  QuickB2B Wholesale
//Created by Sazid Saifi on 5/21/21.

import UIKit

struct GetUserItemsModel: Codable {
    var status: Int?
    var outlets: Int?
    var message: String?
    var outlet_name: String?
    var APP_NAME: String?
    var DAYSLIMIT: String?
    var show_price: String?
    var show_delivery: Int?
    var show_po: Int?
    var delivery_charge: String?
    var min_order_value: String?
    var customer_type: String?
    var show_pickup: Int?
    var pickup_contact: String?
    var route_assigned: Int?
    var show_image: String?
    var featured_item_image: String?
    var currency_code: String?
    var currency_symbol: String?
    var category_exists: Int?
    var data: [GetItemsData]?
    var data_with_category: [GetItemsWithCategoryData]?
    var delivery_available:GetDeliveryAvailableData?
    var delivery_available_dates:[String]?
    let showItemInGrid, showAppBanner: Int?
    let bannerLists: [BannerList]?
    let multi_items: [GetItemsData]?
    let minimum_order_qty: Int?
    let displayAllItemsInApp: Bool?
    
    enum codingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case outlets = "outlets"
        case outlet_name = "outlet_name"
        case APP_NAME = "APP_NAME"
        case DAYSLIMIT = "DAYSLIMIT"
        case show_price = "show_price"
        case show_delivery = "show_delivery"
        case show_po = "show_po"
        case delivery_charge = "delivery_charge"
        case min_order_value = "min_order_value"
        case customer_type = "customer_type"
        case show_pickup = "show_pickup"
        case pickup_contact = "pickup_contact"
        case route_assigned = "route_assigned"
        case show_image = "show_image"
        case featured_item_image = "featured_item_image"
        case currency_code = "currency_code"
        case currency_symbol = "currency_symbol"
        case category_exists = "category_exists"
        case data = "data"
        case data_with_category = "data_with_category"
        case delivery_available = "delivery_available"
        case delivery_available_dates = "delivery_available_dates"
        case showItemInGrid = "show_item_in_grid_view"
        case showAppBanner = "show_app_banner"
        case bannerLists = "bannerLists"
        case multi_items = "multi_items"
        case minimum_order_qty = "minimum_order_qty"
        case displayAllItemsInApp = "display_all_items_in_app"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        outlets = try? (values.decodeIfPresent(Int.self,forKey: .outlets))
        outlet_name = try? (values.decodeIfPresent(String.self,forKey: .outlet_name))
        APP_NAME = try? (values.decodeIfPresent(String.self,forKey: .APP_NAME))
        DAYSLIMIT = try? (values.decodeIfPresent(String.self,forKey: .DAYSLIMIT))
        show_price = try? (values.decodeIfPresent(String.self,forKey: .show_price))
        show_po = try? (values.decodeIfPresent(Int.self,forKey: .show_po))
        show_delivery = try? (values.decodeIfPresent(Int.self,forKey: .show_delivery))
        delivery_charge = try? (values.decodeIfPresent(String.self,forKey: .delivery_charge))
        min_order_value = try? (values.decodeIfPresent(String.self,forKey: .min_order_value))
        customer_type = try? (values.decodeIfPresent(String.self,forKey: .customer_type))
        show_pickup = try? (values.decodeIfPresent(Int.self,forKey: .show_pickup))
        pickup_contact = try? (values.decodeIfPresent(String.self,forKey: .pickup_contact))
        route_assigned = try? (values.decodeIfPresent(Int.self,forKey: .route_assigned))
        show_image = try? (values.decodeIfPresent(String.self,forKey: .show_image))
        featured_item_image = try? (values.decodeIfPresent(String.self,forKey: .featured_item_image))
        currency_code = try? (values.decodeIfPresent(String.self,forKey: .currency_code))
        currency_symbol = try? (values.decodeIfPresent(String.self,forKey: .currency_symbol))
        category_exists = try? (values.decodeIfPresent(Int.self,forKey: .category_exists))
        data = try? (values.decodeIfPresent([GetItemsData].self,forKey: .data))
        data_with_category = try? (values.decodeIfPresent([GetItemsWithCategoryData].self,forKey: .data_with_category))
        delivery_available = try? (values.decodeIfPresent(GetDeliveryAvailableData.self,forKey: .delivery_available))
        delivery_available_dates = try? (values.decodeIfPresent([String].self,forKey: .delivery_available_dates))
        showItemInGrid = try? (values.decodeIfPresent(Int.self,forKey: .showItemInGrid))
        showAppBanner = try? (values.decodeIfPresent(Int.self,forKey: .showAppBanner))
        bannerLists = try? (values.decodeIfPresent([BannerList].self,forKey: .bannerLists))
        multi_items = try? (values.decodeIfPresent([GetItemsData].self,forKey: .multi_items))
        minimum_order_qty = try? (values.decodeIfPresent(Int.self,forKey: .minimum_order_qty))
        displayAllItemsInApp = try? (values.decodeIfPresent(Bool.self,forKey: .displayAllItemsInApp))
    }
}

struct GetItemsData: Codable {
    var id :Int?
    var priority: Int?
    var item_code: String?
    var item_name: String?
    var status: String?
    var uom: String?
    var quantity: String?
    var comment: String?
    var special_item_id: Int?
    var special_title: Int?
    var is_delete:Int?
    var is_meas_box: Int?
    var order_by: String?
    var order_by_cat: String?
    var portion: String?
    var item_price: String?
    var image_description: String?
    var image: String?
    var thumb_image: String?
    var isSlected: Bool = false
    var retail_category_id: Int?
    var category_id: Int?
    var inMyList: Int?
    var show_image: String?
    var next_delivery_date: String?
    var measureQty: String?
    var originQty:String?
    
    enum codingKeys: String, CodingKey{
        case id = "id"
        case priority = "priority"
        case item_code = "item_code"
        case item_name = "item_name"
        case status = "status"
        case uom = "uom"
        case quantity = "quantity"
        case comment = "comment"
        case special_item_id = "special_item_id"
        case special_title = "special_title"
        case is_delete = "is_delete"
        case order_by = "order_by"
        case order_by_cat = "order_by_cat"
        case portion = "portion"
        case item_price = "item_price"
        case image_description = "image_description"
        case image = "image"
        case thumb_image = "thumb_image"
        case retail_category_id = "retail_category_id"
        case category_id = "category_id"
        case inMyList = "inMyList"
        case show_image = "show_image"
        case next_delivery_date = "next_delivery_date"
        case is_meas_box = "is_meas_box"
        case measureQty = "measureQty"
        case originQty = "originQty"
        
    }
    
    init(){
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        item_code = try? (values.decodeIfPresent(String.self,forKey: .item_code))
        item_name = try? (values.decodeIfPresent(String.self,forKey: .item_name))
        status = try? (values.decodeIfPresent(String.self,forKey: .status))
        uom = try? (values.decodeIfPresent(String.self,forKey: .uom))
        quantity = try? (values.decodeIfPresent(String.self,forKey: .quantity))
        comment = try? (values.decodeIfPresent(String.self,forKey: .comment))
        special_item_id = try? (values.decodeIfPresent(Int.self,forKey: .special_item_id))
        special_title = try? (values.decodeIfPresent(Int.self,forKey: .special_title))
        is_delete = try? (values.decodeIfPresent(Int.self,forKey: .is_delete))
        order_by = try? (values.decodeIfPresent(String.self,forKey: .order_by))
        order_by_cat = try? (values.decodeIfPresent(String.self,forKey: .order_by_cat))
        portion = try? (values.decodeIfPresent(String.self,forKey: .portion))
        item_price = try? (values.decodeIfPresent(String.self,forKey: .item_price))
        image_description = try? (values.decodeIfPresent(String.self,forKey: .image_description))
        image = try? (values.decodeIfPresent(String.self,forKey: .image))
        thumb_image = try? (values.decodeIfPresent(String.self,forKey: .thumb_image))
        retail_category_id = try? (values.decodeIfPresent(Int.self,forKey: .retail_category_id))
        category_id = try? (values.decodeIfPresent(Int.self,forKey: .category_id))
        inMyList = try? (values.decodeIfPresent(Int.self,forKey: .inMyList))
        show_image = try? (values.decodeIfPresent(String.self,forKey: .show_image))
        next_delivery_date = try? (values.decodeIfPresent(String.self,forKey: .next_delivery_date))
        is_meas_box = try? (values.decodeIfPresent(Int.self,forKey: .is_meas_box))
        measureQty = try? (values.decodeIfPresent(String.self,forKey: .measureQty))
        originQty = try? (values.decodeIfPresent(String.self,forKey: .originQty))
        id = try? (values.decodeIfPresent(Int.self,forKey: .id))
        priority = try? (values.decodeIfPresent(Int.self,forKey: .priority))
    }
}

struct GetItemsWithCategoryData: Codable {
    var category_title: String?
    var data: [GetItemsData]?
    var item_codes: [String]?
    var isSlected: Bool = false

    enum codingKeys: String, CodingKey{
        case category_title = "category_title"
        case data = "data"
        case item_codes = "item_codes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        category_title = try? (values.decodeIfPresent(String.self,forKey: .category_title))
        data = try? (values.decodeIfPresent([GetItemsData].self,forKey: .data))
        item_codes = try? (values.decodeIfPresent([String].self,forKey: .item_codes))
       
    }
}


struct GetCategoryItemsData: Codable {
    
    var item_code: String?
    var item_name: String?
    var status: String?
    var uom: String?
    var quantity: String?
    var comment: String?
    var special_item_id: Int?
    var special_title: Int?
    var order_by: String?
    var order_by_cat: String?
    var portion: String?
    var item_price: Int?
    var image_description: String?
    var image: String?
    var thumb_image: String?
    

    enum codingKeys: String, CodingKey{
        case item_code = "item_code"
        case item_name = "item_name"
        case status = "status"
        case uom = "uom"
        case quantity = "quantity"
        case comment = "comment"
        case special_item_id = "special_item_id"
        case special_title = "special_title"
        case order_by = "order_by"
        case order_by_cat = "order_by_cat"
        case portion = "portion"
        case item_price = "item_price"
        case image_description = "image_description"
        case image = "image"
        case thumb_image = "thumb_image"
     
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        item_code = try? (values.decodeIfPresent(String.self,forKey: .item_code))
        item_name = try? (values.decodeIfPresent(String.self,forKey: .item_name))
        status = try? (values.decodeIfPresent(String.self,forKey: .status))
        uom = try? (values.decodeIfPresent(String.self,forKey: .uom))
        quantity = try? (values.decodeIfPresent(String.self,forKey: .quantity))
        comment = try? (values.decodeIfPresent(String.self,forKey: .comment))
        special_item_id = try? (values.decodeIfPresent(Int.self,forKey: .special_item_id))
        special_title = try? (values.decodeIfPresent(Int.self,forKey: .special_title))
        order_by = try? (values.decodeIfPresent(String.self,forKey: .order_by))
        order_by_cat = try? (values.decodeIfPresent(String.self,forKey: .order_by_cat))
        portion = try? (values.decodeIfPresent(String.self,forKey: .portion))
        item_price = try? (values.decodeIfPresent(Int.self,forKey: .item_price))
        image_description = try? (values.decodeIfPresent(String.self,forKey: .image_description))
        image = try? (values.decodeIfPresent(String.self,forKey: .image))
        thumb_image = try? (values.decodeIfPresent(String.self,forKey: .thumb_image))
     
    }
}

struct GetDeliveryAvailableData: Codable {
    
    var sun: Int?
    var mon: Int?
    var tue: Int?
    var wed: Int?
    var thu: Int?
    var fri: Int?
    var sat: Int?
  
    enum codingKeys: String, CodingKey{
        case sun = "sun"
        case mon = "mon"
        case tue = "tue"
        case wed = "wed"
        case thu = "thu"
        case fri = "fri"
        case sat = "sat"

    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: codingKeys.self)
        sun = try? (values.decodeIfPresent(Int.self,forKey: .sun))
        mon = try? (values.decodeIfPresent(Int.self,forKey: .mon))
        tue = try? (values.decodeIfPresent(Int.self,forKey: .tue))
        wed = try? (values.decodeIfPresent(Int.self,forKey: .wed))
        thu = try? (values.decodeIfPresent(Int.self,forKey: .thu))
        fri = try? (values.decodeIfPresent(Int.self,forKey: .fri))
        sat = try? (values.decodeIfPresent(Int.self,forKey: .sat))
     
    }
}

// MARK: - GetUserProductModel
struct GetUserProductModel: Codable {
    let message: String?
    let status: Int?
    let showPrice: String?
    var show_image: String?
    var show_pickup: Int?
    var customer_type: String?
    let showItemInGridView, showAppBanner: Int?
    let data: DataClass?
    var currency_symbol: String?
    var delivery_charge: String?
    var min_order_value: String?
    var show_po: Int?
    var showAllItem: Bool?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case showPrice = "show_price"
        case showItemInGridView = "show_item_in_grid_view"
        case showAppBanner = "show_app_banner"
        case show_image = "show_image"
        case customer_type = "customer_type"
        case show_pickup = "show_pickup"
        case currency_symbol = "currency_symbol"
        case delivery_charge = "delivery_charge"
        case min_order_value = "min_order_value"
        case data = "data"
        case show_po = "show_po"
        case showAllItem = "display_all_items_in_app"
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: codingKeys.self)
//        message = try? (values.decodeIfPresent(String.self,forKey: .message))
//        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
//        showPrice = try? (values.decodeIfPresent(String.self,forKey: .showPrice))
//        show_image = try? (values.decodeIfPresent(String.self,forKey: .show_image))
//        showItemInGridView = try? (values.decodeIfPresent(String.self,forKey: .showItemInGridView))
//        showAppBanner = try? (values.decodeIfPresent(String.self,forKey: .showAppBanner))
//        data = try? (values.decodeIfPresent(DataClass.self,forKey: .data))
//    }
}

// MARK: - DataClass]
struct DataClass: Codable {
    let bannerLists: [BannerList]?
    let data: [GetItemsData]?
    let multi_items: [GetItemsData]?
    enum CodingKeys: String, CodingKey {
        case bannerLists = "bannerLists"
        case data = "inventoriesList"
        case multi_items = "multi_items"
    }
}

