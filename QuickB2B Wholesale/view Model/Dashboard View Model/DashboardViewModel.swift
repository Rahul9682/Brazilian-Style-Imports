//
//  DashboardViewModel.swift
//  QuickB2BWholesale
//
//  Created by Sazid Saifi on 05/06/23.
//

import Foundation
import UIKit
import SwiftyJSON

class DashboardViewModel {
    //MARK: - Properties
    var dotLocation = Int()
    var isLongPressGestureRecogized = false
    var showPO  = 0
    var strDeliveryPickUP = ""
    var isRouteAssigned = false
    var arrItemsData = [GetItemsData]()
    var arrItemsDataNew = [GetItemsData]()
    var arrItemsCategoryData = [GetItemsWithCategoryData]()
    var arrItemsDataToSend = [GetItemsData]()
    var arrLongPressGesture = [GetItemsData]()
    var showImage  = ""
    var isResetList = false
    var strResetValue = ""
    var strMinOrderValue = ""
    var showPrice = ""
    var floatTotalPrice :Float! = 0.0
    var specialItemIndex =  0
    var strDeliveryCharge = ""
    var deliveryAvailableDays:GetDeliveryAvailableData?
    var deliveryAvailabelDates = [String]()
    var strDate = ""
    var selectedIndexPath = NSIndexPath(row: 0, section: 0)
    var isCategoryExist = false
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    var indexPathCategory = 0
    var strContactNumber = ""
    var isPickUpDeliveryAvailable = false
    var isComingFromReviewOrderButton = false
    var isMenuButtonSelected = false
    var pickerView:UIPickerView?
    let toolBar = UIToolbar()
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var selectSupplier = 0
    var strSupplierNamePicker = ""
    var strClientCodePicker = ""
    var strUserCodePicker  = ""
    var isSelectOutlet = false

}

//MARK: -> Api Integration
extension DashboardViewModel {
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
            case .success(let data):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
    
    //Delete-Item
    func deleteItem(with param: [String: Any],view:UIView,deletedRowIndexPath:Int,itemCode:String, completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
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
    
    //Get-Featured-Item
    func getFeaturedProduct(with param: [String: Any], view: UIView, completionHandler: @escaping ((Result<FeaturedProductModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.featuredProduct) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<FeaturedProductModel?>(url: url)
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
            case .success(let featuredProductData):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
    
    func updateProductList(with param: [String: Any], view: UIView ,completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.updateUserProductList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<DeleteItemModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        if(self.isMenuButtonSelected == false) {
            DispatchQueue.main.async { CustomActivityIndicator.showIndicator()
                view.isUserInteractionEnabled = false
            }
        }
        WebService().load(resource: resource) { [self] result in
            if(self.isMenuButtonSelected == false) {
                DispatchQueue.main.async { CustomActivityIndicator.hideIndicator()
                    view.isUserInteractionEnabled = true
                }
            }
            switch result{
            case .success(_):
                completionHandler(result)
            case .failure(let error):
                completionHandler(result)
            }
        }
    }
}
