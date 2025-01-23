//  ConfirmPaymentViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 06/06/23.

import Foundation
import UIKit
import SwiftyJSON

class ConfirmPaymentViewModel {
    //MARK: -> Properties
    var arrItemsCategoryData = [GetItemsWithCategoryData]()
    var arrItemsData = [GetItemsData]()
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var arrSelectedItems = [GetItemsData]()
}

//MARK: -> Api-Integration
extension ConfirmPaymentViewModel {
     func confirmAndPay(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<DeleteItemModel?, NetworkError>?) -> ()) ) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.confirmOrder) else { fatalError("URL is incorrect.") }
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
            case .failure(_):
                completionHandler(result)
            }
        }
    }
    
    //Get User Items
    func getItems(with param: [String: Any],completionHandler: @escaping ((Result<GetUserItemsModel?, NetworkError>?) -> ())) {
        print(JSON(param))
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getItems) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetUserItemsModel?>(url: url)
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
}
