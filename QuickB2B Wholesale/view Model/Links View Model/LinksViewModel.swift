//  LinksViewModel.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation
import UIKit

class LinksViewModel {
    //MARK: -> Properties
    var arrWebsiteData = [GetWebsitesData]()
    var arrPdfData = [GetPdfData]()
    var arrLinks = [GetLinksData]()
    var strRequestAccount = ""
    var strEmail = ""
    var strCall = ""
    var db:DBHelper = DBHelper()
    var arrSuppliers = [[String:Any]]()
    var floatTotalPrice :Float! = 0.0
}
    
//MARK: -> Api-Integration
extension LinksViewModel {
     func fetchLinks(with param: [String: Any],view: UIView,completionHandler: @escaping ((Result<FetchLinksModel?, NetworkError>?) -> ())) {
        guard let url = URL(string: GlobalConstantClass.APIConstantNames.baseUrl + GlobalConstantClass.APIConstantNames.fetchLinks) else { fatalError("URL is incorrect.") }
        print(url)
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed) else { fatalError("Error encoding order.") }
        var resource = Resource<FetchLinksModel?>(url: url)
        resource.httpMethods = .post
        resource.body = data
        
        DispatchQueue.main.async { Constants.showIndicator()
            view.isUserInteractionEnabled = false
        }
        WebService().load(resource: resource) { result in
            DispatchQueue.main.async { Constants.hideIndicator()
                view.isUserInteractionEnabled = true
            }
            
            switch result {
            case .success(_):
                completionHandler(result)
            case .failure(_):
                completionHandler(result)
            }
        }
    }
}
