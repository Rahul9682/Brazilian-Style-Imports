//  ProductsViewModel.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 25/04/23.

import Foundation
import SwiftyJSON

class ProductsViewModel {
    var arrItemsCategoryData = [GetItemsWithCategoryData]()
    var arrayOfListItems = [GetItemsData]()
    var arrayOfFilteredData = [GetItemsData]()
    var arrayOfChips = [CategoryData]()
    var arrayOfNewListItems = [GetItemsData]()
    var arrayOfItemsToSend = [GetItemsData]()
    var strResetValue = ""
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var itemCode = ""
    var floatTotalPrice :Float! = 0.0
    var showImage: String = "1"
    var showPrice  = ""
    var strDeliveryCharge = ""
    var isCategoryExist = false
    var isComingFromReviewOrderButton = false
    var isClickCart = false
    var strDeliveryPickUP = ""
    var strMinOrderValue = ""
    var showPO = 0
    var arrayOfBanner = [BannerList]()
    var arrayOfLocalStorageItems = LocalStorage.getItemsData()
    
    //MARK: -> Param
    func AddProductParam() -> [String: Any?] {
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
        let param = [addProductParam.user_code.rawValue: userCode,
                     addProductParam.client_code.rawValue: KeyConstants.clientCode,
                     addProductParam.item_code.rawValue: itemCode,
                     addProductParam.device_id.rawValue: Constants.deviceId] as [String : Any?]
        print(JSON(param))
        return param
    }
}

//MARK: -> Api- Integration
extension ProductsViewModel {
    func searchItemByCategory(page: Int,with param: [String: Any],completionHandler: @escaping ((Result<GetUserProductModel?, NetworkError>?) -> ())) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.searchItemByCategoryV3) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetUserProductModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        if page == 1 {
            DispatchQueue.main.async {Constants.showIndicator()}
        }
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async {Constants.hideIndicator()}
            switch result {
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    func getCategories(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<GetCategoryModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getCategoriesV3) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetCategoryModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { Constants.hideIndicator()
                view.isUserInteractionEnabled = true
            }
            
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    //AddProduct
    func addProduct(with param: [String: Any] ,view: UIView,completionHandler: @escaping ((Result<AddProductModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.addProduct) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<AddProductModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            
            DispatchQueue.main.async { Constants.hideIndicator()
                view.isUserInteractionEnabled = true
            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    //Get-Items-By-Category
    func searchItemsByCategory(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<SearchItemsByCategory?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.searchItemByCategoryV3) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<SearchItemsByCategory?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { Constants.hideIndicator()
                view.isUserInteractionEnabled = true
            }
            
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    //update-Product-List
    func updateProductList(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.updateUserProductList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        //        DispatchQueue.main.async { Constants.showIndicator()
        //            view.isUserInteractionEnabled = false
        //        }
        WebService().load(resource: resource) { [self] result in
            //            DispatchQueue.main.async { Constants.hideIndicator()
            //                view.isUserInteractionEnabled = true
            //            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    
    //Delete-Item
    func deleteItem(with param: [String: Any],view:UIView,itemCode:String, completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.deleteItemAPI) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { Constants.hideIndicator()
                view.isUserInteractionEnabled = true
            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
    
    func carartItemsList(with param: [String: Any],completionHandler: @escaping ((Result<HomeModel?, NetworkError>?) -> ())) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.cartItemsV3) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<HomeModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { Constants.showIndicator()}
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { Constants.hideIndicator()}
            switch result{
            case .success(let cartData):
                if let cartData = cartData {
                    guard let status = cartData.status else { return }
                    if (status == 1) {
                        LocalStorage.clearItemsData()
                        if let cartData = cartData.data {
                            if let allInventories = cartData.allInventories {
                                LocalStorage.saveItemsData(data: allInventories)
                                let notificationCenter = NotificationCenter.default
                                notificationCenter.post(name: Notification.Name("cartSucess"), object: nil, userInfo: nil)
                            }
                        }
                        
                        if let currencySymbol = cartData.currency_symbol {
                            if(currencySymbol != ""){
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            } else {
                                UserDefaults.standard.set(currencySymbol, forKey:UserDefaultsKeys.CurrencySymbol)
                            }
                        }
                        
                        if let showPrice  = cartData.showPrice {
                            UserDefaults.standard.set(showPrice, forKey: UserDefaultsKeys.showPrice)
                        }
                        completionHandler(result)
                    } else {
                        completionHandler(result)
                    }
                }
            case .failure(let error):
                print("error")
            }
        }
    }
    
    func registerUserDevice(with param: [String: Any],completionHandler: @escaping ((Result<GetPushNotificationModel?, NetworkError>?) -> ())) {
        print(JSON(param))
        
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getPushNotification) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetPushNotificationModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { Constants.showIndicator()}
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { Constants.hideIndicator()}
            switch result{
            case .success(let getPushNotificationData):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
}
