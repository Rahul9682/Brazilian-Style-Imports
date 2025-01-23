//  HomeViewModel.swift
//  GenericWholeSaleV3
//  Created by Sazid Saifi on 19/04/23.

import Foundation
import SwiftyJSON

class HomeViewModel {
    /////****////
    var homeData: HomeData?
    var arrayOfCategory = [AllCategory]()
    var arrayOfSpecial = [GetItemsData]()
    var featuredItem: FeaturedItem?
    var arrayOfBanner = [BannerList]()
    var itemCode = ""
    var isMenuButtonSelected = false
    var isComingFromReviewOrderButton = false
    var showImage = "0"
    var floatTotalPrice :Float! = 0.0
    var showPrice = "0"
    var isCategoryExist: Bool = false
    var showMyProduct = 0
    var noOfOutlets = 0
    var arrayOfNewSpecials = [GetItemsData]()
    var arrayOfAllInventory = [GetItemsData]()
    var arrayOfNewAllInventory = [GetItemsData]()
    var arrayOfLocalStorageItems = LocalStorage.getItemsData()
    var acmCode  = UserDefaults.standard.string(forKey: UserDefaultsKeys.acmLoginID)
    
    //MARK: Helpers
    func param() -> [String: Any?] {
        let userCode = UserDefaults.standard.value(forKey:UserDefaultsKeys.UserLoginID) as? String
        let param = [homeParam.user_code.rawValue: userCode,
                     homeParam.client_code.rawValue: KeyConstants.clientCode,
                     homeParam.device_id.rawValue: Constants.deviceId,
                     homeParam.acm_code.rawValue:acmCode
                  ] as [String : Any?]
        print(JSON(param))
        return param
    }
    
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

//MARK: -> Api-Integration
extension HomeViewModel {
    func getHomeData(with param: [String: Any], completionHandler: @escaping ((HomeModel?, String?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.home) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        print("url:-", url)
        var resource = Resource<HomeModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator() }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { Constants.hideIndicator() }
            
            switch result {
            case .success(let data):
                if let data = data {
                    completionHandler(data, nil)
                }
            case .failure(let error):
                let error = error.localizedDescription
                completionHandler(nil, error)
            }
        }
    }
    
    //MARK: - Add-Item
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
    
    //update-Product-List
    func updateProductList(with param: [String: Any], view: UIView ,completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.updateUserProductList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
//        if(self.isMenuButtonSelected == false) {
//            DispatchQueue.main.async {
        Constants.showIndicator()
//                view.isUserInteractionEnabled = false
//            }
//        }
        WebService().load(resource: resource) { [self] result in
//            if(self.isMenuButtonSelected == false) {
//                DispatchQueue.main.async { 
            Constants.hideIndicator()
//                    view.isUserInteractionEnabled = true
//                }
//            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
    
    //Get-Items
    func getItems(with param: [String: Any],completionHandler: @escaping ((Result<HomeModel?, NetworkError>?) -> ())) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getItems) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<HomeModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { Constants.showIndicator()
            //self.view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { [self] result in
            
            DispatchQueue.main.async { Constants.hideIndicator()
                //self.view.isUserInteractionEnabled = true
            }
            switch result {
            case .success(let data):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
    
    
    //Get-Featured-Item
    func getFeaturedProduct(with param: [String: Any], view: UIView, completionHandler: @escaping ((Result<FeaturedProductModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.featuredProduct) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<FeaturedProductModel?>(url: url)
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
            case .success(let featuredProductData):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
    
    //MARK: - Delete-Item
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
}


//MARK: -> Binding-Data
extension HomeViewModel {
    func bindHomeData(completionHandler: @escaping ((Bool, String) -> ())) {
        self.getHomeData(with: self.param() as [String : Any]) { data, error in
            if let data = data {
                if let status = data.status {
                    if status == 1 {
                        //SaveAuthentication.saveLoginDetails(with: data.data)
                        if let homeData = data.data {
                            self.homeData = homeData
                            
                            if let bannerLists = homeData.bannerLists {
                                self.arrayOfBanner = bannerLists
                            }
                            
                            if let specialItemList = homeData.specialInventories {
                                self.arrayOfSpecial = specialItemList
                            }
                            
                            if let featuredData = homeData.featuredItem {
                                self.featuredItem = featuredData
                            }
                            
                            if let allcategory = homeData.allCategories {
                                self.arrayOfCategory = allcategory
                            }
                        }
                        let message = data.message ?? ""
                        completionHandler(true, message)
                    } else {
                        let message = data.message ?? ""
                        completionHandler(false, message)
                    }
                }
            }
            if let error = error {
                completionHandler(false, error)
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
