//
//  CustomerListViewModel.swift
//  QuickB2B
//
//  Created by Braintech on 24/10/24.
//

import Foundation
import UIKit
import SwiftyJSON

class CustomerListViewModel {
    
    
    //MARK: - Properties
    var arrSuppliers = [[String:Any]]()
    var db:DBHelper = DBHelper()
    
    //MARK: - Helpers
    func getCustomerListing(with param: [String: Any] ,view: UIView,completionHandler: @escaping ((Result<CustomerListModel?, NetworkError>?) -> ())) {
        print(param)
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.customerList) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<CustomerListModel?>(url: url)
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
    
    func getCustomerDetails(with param: [String: Any] ,view: UIView,completionHandler: @escaping ((Result<CustomerDetailModel?, NetworkError>?) -> ())) {
        print(param)
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.customerDetails) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<CustomerDetailModel?>(url: url)
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
    
    func getPushNotification(with param: [String: Any],completionHandler: @escaping ((Result<GetPushNotificationModel?, NetworkError>?) -> ())) {
       print(JSON(param))
       
       guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getPushNotification) else { fatalError("URL is incorrect.") }
       print(url)
       guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
       var resource = Resource<GetPushNotificationModel?>(url: url)
       resource.httpMethods = .post
       resource.body = data
       WebService().load(resource: resource) { [self] result in
           switch result{
           case .success(let getPushNotificationData):
             completionHandler(result)
           case .failure(let error):
               completionHandler(result)
           }
       }
   }
}
