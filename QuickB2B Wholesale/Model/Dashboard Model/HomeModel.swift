//
//  HomeModel.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 19/04/23.
//

import Foundation

struct CategoryDataHome {
    var image: String?
    var category: String?
}

struct SpecialItemsData {
    var image: String?
    var productName: String?
    var price: String?
    var isFavourite: Bool = false
}

struct ReviewOrderData {
    var image: String?
    var isImage: Bool = false
    var productName: String?
    var price: String?
    var qty: String?
}

//***********************************************************************//
// MARK: - HomeModel
struct HomeModel: Codable {
    let message: String?
    let status, outlets: Int?
    let outletName, appName, dayslimit, showPrice: String?
    let showDelivery, showPo: Int?
    let customerType: String?
    let data: HomeData?
    let showItemInGrid, showAppBanner: Int?
    let show_my_product: Int?
    let currency_symbol: String?
    let app_version_update: String?
    let app_version_update_type: String?
    let app_version_update_content: String?
    let show_image: String?
    let displayAllItems: Bool?

    enum CodingKeys: String, CodingKey {
        case message, status, outlets
        case outletName = "outlet_name"
        case appName = "APP_NAME"
        case dayslimit = "DAYSLIMIT"
        case showPrice = "show_price"
        case showDelivery = "show_delivery"
        case showPo = "show_po"
        case customerType = "customer_type"
        case data = "data"
        case showItemInGrid = "show_item_in_grid_view"
        case showAppBanner = "show_app_banner"
        case show_my_product = "show_my_product"
        case currency_symbol = "currency_symbol"
        case app_version_update = "app_version_update"
        case app_version_update_type = "app_version_update_type"
        case app_version_update_content = "app_version_update_content"
        case show_image = "show_image"
        case displayAllItems = "display_all_items_in_app"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try? (values.decodeIfPresent(String.self,forKey: .message))
        status = try? (values.decodeIfPresent(Int.self,forKey: .status))
        outlets = try? (values.decodeIfPresent(Int.self,forKey: .outlets))
        outletName = try? (values.decodeIfPresent(String.self,forKey: .outletName))
        appName = try? (values.decodeIfPresent(String.self,forKey: .appName))
        dayslimit = try? (values.decodeIfPresent(String.self,forKey: .dayslimit))
        showPrice = try? (values.decodeIfPresent(String.self,forKey: .showPrice))
        showDelivery = try? (values.decodeIfPresent(Int.self,forKey: .showDelivery))
        showPo = try? (values.decodeIfPresent(Int.self,forKey: .showPo))
        customerType = try? (values.decodeIfPresent(String.self,forKey: .customerType))
        data = try? (values.decodeIfPresent(HomeData.self,forKey: .data))
        showItemInGrid = try? (values.decodeIfPresent(Int.self,forKey: .showItemInGrid))
        showAppBanner = try? (values.decodeIfPresent(Int.self,forKey: .showAppBanner))
        show_my_product = try? (values.decodeIfPresent(Int.self,forKey: .show_my_product))
        currency_symbol = try? (values.decodeIfPresent(String.self,forKey: .currency_symbol))
        app_version_update = try? (values.decodeIfPresent(String.self,forKey: .app_version_update))
        app_version_update_type = try? (values.decodeIfPresent(String.self,forKey: .app_version_update_type))
        app_version_update_content = try? (values.decodeIfPresent(String.self,forKey: .app_version_update_content))
        show_image = try? (values.decodeIfPresent(String.self,forKey: .show_image))
        displayAllItems = try? (values.decodeIfPresent(Bool.self,forKey: .displayAllItems))
    }
}

// MARK: - HomeData
struct HomeData: Codable {
    let categoryExists: Int?
    let allCategories: [AllCategory]?
    let specialInventories: [GetItemsData]?
    let featuredItem: FeaturedItem?
    let bannerLists: [BannerList]?
    let allInventories:[GetItemsData]?
    let multi_items:[GetItemsData]?

    enum CodingKeys: String, CodingKey {
        case categoryExists = "category_exists"
        case allCategories = "all_categories"
        case specialInventories = "special_inventories"
        case featuredItem = "featured_item_image"
        case bannerLists = "bannerLists"
        case allInventories = "all_inventories"
        case multi_items = "multi_items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryExists = try? (values.decodeIfPresent(Int.self,forKey: .categoryExists))
        allCategories = try? (values.decodeIfPresent([AllCategory].self,forKey: .allCategories))
        specialInventories = try? (values.decodeIfPresent([GetItemsData].self,forKey: .specialInventories))
        featuredItem = try? (values.decodeIfPresent(FeaturedItem.self,forKey: .featuredItem))
        bannerLists = try? (values.decodeIfPresent([BannerList].self,forKey: .bannerLists))
        allInventories = try? (values.decodeIfPresent([GetItemsData].self,forKey: .allInventories))
        multi_items = try? (values.decodeIfPresent([GetItemsData].self,forKey: .multi_items))
    }
}

// MARK: - BannerList
struct BannerList: Codable {
    let image: String?
    let bannerText: String?
    let linkItem: Int?
    let linkItemType: String?
    let linkItemTypeID: String?

    enum CodingKeys: String, CodingKey {
        case image = "image"
        case bannerText = "banner_text"
        case linkItem = "link_item"
        case linkItemType = "link_item_type"
        case linkItemTypeID = "link_item_type_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try? (values.decodeIfPresent(String.self,forKey: .image))
        bannerText = try? (values.decodeIfPresent(String.self,forKey: .bannerText))
        linkItem = try? (values.decodeIfPresent(Int.self,forKey: .linkItem))
        linkItemType = try? (values.decodeIfPresent(String.self,forKey: .linkItemType))
        linkItemTypeID = try? (values.decodeIfPresent(String.self,forKey: .linkItemTypeID))
    }
}

// MARK: - AllCategory
struct AllCategory: Codable {
    let id: Int?
    let name: String?
    let thumbImage: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case thumbImage = "thumb_image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? (values.decodeIfPresent(Int.self,forKey: .id))
        name = try? (values.decodeIfPresent(String.self,forKey: .name))
        thumbImage = try? (values.decodeIfPresent(String.self,forKey: .thumbImage))
    }
}

// MARK: - FeaturedItemImage
struct FeaturedItem: Codable {
    let image: String?
    let content, price, date: String?
    let visibility, show, onLogin, onLaunch: Int?

    enum CodingKeys: String, CodingKey {
        case image = "image"
        case content = "content"
        case price = "price"
        case date = "date"
        case visibility = "visibility"
        case show = "show"
        case onLogin = "on_login"
        case onLaunch = "on_launch"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try? (values.decodeIfPresent(String.self,forKey: .image))
        content = try? (values.decodeIfPresent(String.self,forKey: .content))
        price = try? (values.decodeIfPresent(String.self,forKey: .price))
        date = try? (values.decodeIfPresent(String.self,forKey: .date))
        visibility = try? (values.decodeIfPresent(Int.self,forKey: .visibility))
        show = try? (values.decodeIfPresent(Int.self,forKey: .show))
        onLogin = try? (values.decodeIfPresent(Int.self,forKey: .onLogin))
        onLaunch = try? (values.decodeIfPresent(Int.self,forKey: .onLaunch))
    }
}

// MARK: - SpecialInventory
struct SpecialItems: Codable {
    var itemCode, itemName, itemPrice, status: String?
    var uom, quantity, comment: String?
    let specialItemID, specialTitle, orderBy, orderByCat: Int?
    let portion, imageDescription: String?
    let image: String?
    let thumbImage: String?
    let categoryID, retailCategoryID, isDelete: Int?

    enum CodingKeys: String, CodingKey {
        case itemCode = "item_code"
        case itemName = "item_name"
        case itemPrice = "item_price"
        case status = "status"
        case uom = "uom"
        case quantity = "quantity"
        case comment = "comment"
        case specialItemID = "special_item_id"
        case specialTitle = "special_title"
        case orderBy = "order_by"
        case orderByCat = "order_by_cat"
        case portion = "portion"
        case imageDescription = "image_description"
        case image = "image"
        case thumbImage = "thumb_image"
        case categoryID = "category_id"
        case retailCategoryID = "retail_category_id"
        case isDelete = "is_delete"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        itemCode = try? (values.decodeIfPresent(String.self,forKey: .itemCode))
        itemName = try? (values.decodeIfPresent(String.self,forKey: .itemName))
        itemPrice = try? (values.decodeIfPresent(String.self,forKey: .itemPrice))
        status = try? (values.decodeIfPresent(String.self,forKey: .status))
        uom = try? (values.decodeIfPresent(String.self,forKey: .uom))
        quantity = try? (values.decodeIfPresent(String.self,forKey: .quantity))
        comment = try? (values.decodeIfPresent(String.self,forKey: .comment))
        specialItemID = try? (values.decodeIfPresent(Int.self,forKey: .specialItemID))
        specialTitle = try? (values.decodeIfPresent(Int.self,forKey: .specialTitle))
        orderBy = try? (values.decodeIfPresent(Int.self,forKey: .orderBy))
        orderByCat = try? (values.decodeIfPresent(Int.self,forKey: .orderByCat))
        portion = try? (values.decodeIfPresent(String.self,forKey: .portion))
        imageDescription = try? (values.decodeIfPresent(String.self,forKey: .imageDescription))
        image = try? (values.decodeIfPresent(String.self,forKey: .image))
        thumbImage = try? (values.decodeIfPresent(String.self,forKey: .thumbImage))
        categoryID = try? (values.decodeIfPresent(Int.self,forKey: .categoryID))
        retailCategoryID = try? (values.decodeIfPresent(Int.self,forKey: .retailCategoryID))
        isDelete = try? (values.decodeIfPresent(Int.self,forKey: .isDelete))
    }
}
