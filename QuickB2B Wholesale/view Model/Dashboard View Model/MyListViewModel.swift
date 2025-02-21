//
//  MyListViewModel.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 21/04/23.
//

import Foundation
import SwiftyJSON

class MyListViewModel {
    var arrItemsCategoryData = [GetItemsWithCategoryData]()
    var arrayOfListItems = [GetItemsData]()
    var arrayOfFilteredData = [GetItemsData]()
    var arrayOfChips = [GetItemsWithCategoryData]()
    var arrayOfNewListItems = [GetItemsData]()
    var isCategoryExist: Bool = false
    var floatTotalPrice :Float! = 0.0
    var strDeliveryCharge = ""
    var deliveryAvailableDays:GetDeliveryAvailableData?
    var deliveryAvailabelDates = [String]()
    //var strDeliveryPickUP = ""
    var isPickUpDeliveryAvailable = false
    var showPO  = 0
    var strContactNumber = ""
    var isRouteAssigned = false
    var arrItemsDataToSend = [GetItemsData]()
    var isComingFromReviewOrderButton = false
    var strMinOrderValue = ""
    var isResetList = false
    var strResetValue = ""
    //
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    var arrLongPressGesture = [GetItemsData]()
    var isLongPressGestureRecogized = false
    var arrayOfBanner = [BannerList]()
    var arrayOfLocalStorageItems = LocalStorage.getItemsData()
    var isMenuButtonSelected = false
    var noOfOutlets = 0
}

extension MyListViewModel {
    func getItems(with param: [String: Any],completionHandler: @escaping ((Result<GetUserItemsModel?, NetworkError>?) -> ())) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getItems) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetUserItemsModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()
            //self.view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()
                //self.view.isUserInteractionEnabled = true
            }
            switch result {
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    //Get-Items-By-Category
    func searchItemsByCategory(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<SearchItemsByCategory?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.searchItemByCategoryNew) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<SearchItemsByCategory?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()
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
    
    func getCategories(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<GetCategoryModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getCategories) else { fatalError("URL is incorrect.") }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetCategoryModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()
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
    
    //Delete-Item
    func deleteItem(with param: [String: Any],view:UIView,itemCode:String, completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.deleteItemAPI) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()
            view.isUserInteractionEnabled = false
        }
        
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()
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
    
    //update-Product-List
    func updateProductList(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.updateUserProductList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        //        if(self.isMenuButtonSelected == false) {
        //            DispatchQueue.main.async { Constants.showIndicator()
        //                view.isUserInteractionEnabled = false
        //            }
        //        }
        
        WebService().load(resource: resource) { [self] result in
            //            if(self.isMenuButtonSelected == false) {
            //                DispatchQueue.main.async { Constants.hideIndicator()
            //                    view.isUserInteractionEnabled = true
            //                }
            //            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(_):
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
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()}
        WebService().load(resource: resource) { [self] result in
            DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()}
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
        DispatchQueue.main.async { CustomActivityIndicator.showIndicator()}
       WebService().load(resource: resource) { [self] result in
           DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()}
           switch result{
           case .success(let getPushNotificationData):
             completionHandler(result)
           case .failure(let error):
               completionHandler(result)
           }
       }
   }
}
