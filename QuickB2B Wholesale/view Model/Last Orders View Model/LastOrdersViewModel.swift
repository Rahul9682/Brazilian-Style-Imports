//  LastOrdersViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation
import SwiftyJSON

class LastOrdersViewModel {
    //MARK: -> Properties
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var arrUserOrderData = [FetchUserData]()
    var arrOrderDetailsData = [GetOrderDetailsData]()
    var arrayOfChips = [AccountChipsData]()
    var arrayOfReorderList = [GetItemsData]()
    var arrayOfReorderMultiList = [GetItemsData]()    
    var floatTotalPrice :Float! = 0.0

}

//MARK: - Api-Integration
extension LastOrdersViewModel {
    //Fetch-User-Order
    func fetchUserOder(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<FetchUserOrderModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.fetchUserOrderV3) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<FetchUserOrderModel?>(url: url)
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
    
    //Get-Order-Details
    func getOrderDetails(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<GetOrderDetailsModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getOrderDetails) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<GetOrderDetailsModel?>(url: url)
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
    
    //Get-reOrder
    func reOrder(with param: [String: Any], view: UIView,completionHandler: @escaping ((Result<ReOrderModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.reOrder) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<ReOrderModel?>(url: url)
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
}
