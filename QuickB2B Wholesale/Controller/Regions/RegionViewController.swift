//
//  RegionViewController.swift
//  Munja Bakehouse
//
//  Created by Braintech on 20/01/25.
//

import UIKit
import DropDown

class RegionViewController: UIViewController, PopUpDelegate {
    
    
    //MARK: - Outlet's
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownImage: UIButton!
    @IBOutlet weak var searchRegionTextfield: UITextField!
    
    
    //MARK: - Properties
    var dropDown = DropDown()
    var arrayOfRegion: [ClientRegion] = []
    var viewModel = SupplierIdViewModel()
    
    
    //MARK: - Life-Cycle-Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationToHome() 
        let userId = UserDefaults.standard.string(forKey:  "UserLoginID")
        if ( userId == nil || userId == "" ) {
            getAppDetails()
        }
        configureUI()
    }
    
    func configureNavigationToHome() {
        if let userId = UserDefaults.standard.string(forKey:  "UserLoginID") {
            let loginId = UserDefaults.standard.object(forKey: UserDefaultsKeys.UserDefaultLoginID) as? String ?? ""
            
            if( userId != "") {
                UserDefaults.standard.set("Yes", forKey: "featuredItemShow")
                UserDefaults.standard.set(true, forKey: "isComingFromDashboard")
                let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(dashboardVC!, animated: false)
            } else if (userId == "" && loginId != "" ) {
                let outLetController = self.storyboard?.instantiateViewController(withIdentifier: "OutletsListController") as? OutletsListController
                self.navigationController?.pushViewController(outLetController!, animated: false)
            }
        } else {
            let acm_Code = UserDefaults.standard.object(forKey: UserDefaultsKeys.acmLoginID) as? String ?? ""
            if (acm_Code != "") {
                let acmController = self.storyboard?.instantiateViewController(withIdentifier: "CustomerListViewController") as? CustomerListViewController
                self.navigationController?.pushViewController(acmController!, animated: false)
            }
        }
    }
    
    func didTapDone() {
       
    }
    
    
    func configureUI() {
        dropDownView.layer.cornerRadius = 4
        dropDown.anchorView = dropDownView
        dropDown.bounds = CGRect(x: 0, y: dropDownView.frame.height-60, width: dropDownView.frame.width - 40,height: dropDownView.frame.height)
        dropDown.width = dropDownView.bounds.width
        dropDown.cornerRadius = 4
        dropDown.backgroundColor = .white
        dropDown.separatorColor = .white
        dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) in
            cell.optionLabel.textAlignment = .center // Change to .left or .right if needed
        }
        let arrayOfRegionName: [String] = self.arrayOfRegion.map { $0.companyName ?? "" }
        dropDown.dataSource = arrayOfRegionName
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchRegionTextfield.text = item
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "SupplierNameViewController") as? SupplierNameViewController {
                vc.selectedRegionIndex = index
                vc.selectedRegion = self.arrayOfRegion[index]
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
        }
    }
    
    func presentPopUpWithDelegate(strMessage:String,buttonTitle:String) {
        DispatchQueue.main.async {
            guard   let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopupVC") as? PopupVC else {return}
            vc.strMessage = strMessage
            vc.buttonTitle = buttonTitle
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func dropDownaction(_ sender: Any) {
        dropDown.show()
        
    }
    
    @IBAction func accessAccount(_ sender: UIButton) {
        let createAnAccountVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateAnAccountViewController") as? CreateAnAccountViewController
        self.navigationController?.pushViewController(createAnAccountVC!, animated: false)
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let forgotPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPasswordVC!, animated: false)
    }
    
}

extension RegionViewController {
    private func getAppDetails() {
        let dictParam = [
            GetAppData.type.rawValue:KeyConstants.appType ,
            GetAppData.app_type.rawValue:KeyConstants.app_Type,
            GetAppData.client_code.rawValue:KeyConstants.clientCode,
            GetAppData.device_id.rawValue:Constants.deviceId] as [String : Any]
        
        viewModel.getAppDetails(with: dictParam) { result in
            switch result {
            case .success(let appDetails):
                if let appDetails = appDetails {
                    guard let status = appDetails.status else { return }
                    if (status == 1) {
                        if let showRegion = appDetails.data?.enableRegionSystem {
                            if showRegion == 1 {
                                if let arrayOfRegion = appDetails.data?.regions {
                                    UserDefaults.standard.setValue(showRegion, forKey: UserDefaultsKeys.showRegion)
                                    LocalStorage.saveRegionData(data: arrayOfRegion)
                                    self.arrayOfRegion = arrayOfRegion
                                    self.configureUI()
                                } else {
                                    
                                }
                            } else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                                    self.navigationController?.pushViewController(vc, animated: false)
                                }
                            }
                            
                        }
                        
                    } else {
                        guard let messge = appDetails.message else {return}
                        self.presentPopUpWithDelegate(strMessage: messge, buttonTitle: "Ok")
                    }
                }
            case .failure(let error):
                if(error == .networkError) {
                    
                } else {
                    
                }
            case .none:
                break
            }
        }
    }
}
