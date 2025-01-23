//  AppInformationViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation
import UIKit

class AppInformationViewModel {
    //MARK: -> Properties
    var comingFrom = ""
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var arrayOfChips = [AccountChipsData]()
    var floatTotalPrice :Float! = 0.0

}

//MARK: -> Api-Integration
extension AppInformationViewModel {
    //Get-AppInformation
     func getAppInformation(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<GetInformationModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.getInformation) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        
        var resource = Resource<GetInformationModel?>(url: url)
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
    
    //Get-FeaturedProduct
     func getFeaturedProduct(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<FeaturedProductModel?, NetworkError>?) -> ())) {
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
            DispatchQueue.main.async { Constants.hideIndicator() }
            switch result {
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
}
