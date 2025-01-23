//  CustomDelegates.swift
//  QuickB2BWholesale
//  Created by Sazid Saifi on 07/06/23.

import Foundation

protocol CalendarDelegate: class {
    func passDate(strDate:String)
}

protocol PopUpDelegate: class {
    func didTapDone()
    
   
}

protocol ShowListDelegate {
    func didShowListTapDone(itemCode:String)
}

protocol ReloadTableViewDelegate {
    func reloadTableView()
}


protocol OpenUrlDelegate {
    func openUrl(url:String)
}

protocol DelegeteProductClick {
    func didClickProduct(index: Int, listingType: ProductListingType)
}

protocol GetProductClickIndex {
    func getIndex(index: Int)
}

protocol DelegeteGetItemCode {
    func itemCode(itemCode: String)
}

protocol DelegeteGetStringText {
    func DelegeteGetStringText(quantity: String, index: Int, measure: String)
}

protocol DelegeteSuccess {
    func isSuceess(success: Bool, text: String)
}

protocol DelegeteMyListSuccess {
    func isSuceess(success: Bool, text: String, index: Int, measureQty:String)
}

protocol DelegateGetText {
    func getText(text: String)
}

protocol DelegeteBannerImageClick {
    func didClickBannerImage(ind: Int)
}

protocol DelegeteSuccessWithListType {
    func isSuccessWithListType(success: Bool, text: String, listType: ProductListingType, measureQty:String)
}


protocol DelegateUpdateQuantity {
    func didUpdateQuantity(updatedQuantity: String,inMyList: Int,indexPath: IndexPath)
}

protocol LogoutDelegate {
    func successLogout()
}

protocol ConfirmationPopupSuccessDelegate {
    func isSuccess(success: Bool)
}

protocol ShowListTableViewCellDelegate {
    func addButtonTapped()
}

protocol RefreshDelegate {
    func refresh()
}
