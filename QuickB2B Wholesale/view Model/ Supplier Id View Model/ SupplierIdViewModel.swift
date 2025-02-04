//   SupplierIdViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation
import SwiftyJSON

class SupplierIdViewModel {
    //MARK: -> Properties
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var logoutString = ""
}

//MARK: -> Api-Integration
extension SupplierIdViewModel {
    func getAppDetails(with param: [String: Any],view: UIView? = nil,completionHandler: @escaping ((Result<AppDetailsModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getCompanyDetails) else { fatalError("URL is incorrect.") }
        
        print(JSON(param))
        print(url)
        
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<AppDetailsModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view?.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            
            DispatchQueue.main.async { Constants.hideIndicator()
                view?.isUserInteractionEnabled = true
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
