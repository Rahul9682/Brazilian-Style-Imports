//
//// CalendarViewController.swift
//// QuickB2B Wholesale
//// Created by Sazid Saifi on 5/23/21.
//
//import UIKit
//import Foundation
//
//import FSCalendar
//class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UIGestureRecognizerDelegate {
//
//    //MARK: - Properties
//    @IBOutlet var viewOuterCalendar: UIView!
//    @IBOutlet var viewCalendar: FSCalendar!
//    @IBOutlet var closeButton: UIButton!
//
//    //MARK: - Properties
//    var delegate:CalendarDelegate!
//    var deliveryAvailableDays:GetDeliveryAvailableData?
//    var deliveryAvailabelDates = [String]()
//
//    //MARK: - LifeCycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewCalendar.customizeCalenderAppearance()
//        viewOuterCalendar.layer.borderWidth = 1
//        //viewOuterCalendar.layer.borderColor = UIColor(red: 40.0/255, green: 152.0/255, blue: 161.0/255, alpha: 1.0).cgColor
//        viewOuterCalendar.layer.borderColor = UIColor.black.cgColor
//        viewCalendar.delegate = self
//        viewCalendar.dataSource = self
//        viewCalendar.reloadData()
//        // Do any additional setup after loading the view.
////        deliveryAvailabelDates.remove(at: 0)
//
//        closeButton.layer.borderWidth = 1
//        closeButton.layer.borderColor = UIColor.white.cgColor
//        closeButton.layer.cornerRadius = 5
//    }
//
//    //MARK: - BUTTON ACTION
//    @IBAction func closeButton(_ sender: UIButton) {
//        self.dismiss(animated: false, completion: nil)
//    }
//
//    //MARK: - FSCalendar Delegates and DataSource
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let currentCalendar =   Calendar(identifier: .gregorian)
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//        let strDate = dateFormatterGet.string(from: date)
//        dateFormatterGet.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//
//        guard let newDate = dateFormatterGet.date(from: strDate) else { return  }
//        dateFormatterGet.dateFormat = "dd/MM/yyyy"
//        dateFormatterGet.calendar = currentCalendar
//        //        dateFormatterGet.timeZone =  TimeZone(identifier: "UTC")!
//        let finalDateString = dateFormatterGet.string(from: newDate)
//        delegate.passDate(strDate: finalDateString)
//        self.dismiss(animated: false, completion: nil)
//    }
//
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        let currentCalendar =   Calendar(identifier: .gregorian)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//        let strDate = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//        guard let newDate = dateFormatter.date(from: strDate) else { return  false}
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.calendar = currentCalendar
//        //        dateFormatter.timeZone =  TimeZone(identifier: "UTC")!
//        let finalDateString = dateFormatter.string(from: newDate)
//
//        for i in 0..<self.deliveryAvailabelDates.count {
//            let deliveryDate = self.deliveryAvailabelDates[i]
//            if(deliveryDate == finalDateString) {
//                return true
//            }
//        }
//        return false
//    }
//
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        let today = Date()
//        let modifiedDate = Calendar.current.date(byAdding: .day, value: 0, to: today)!
//        return modifiedDate
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        let currentCalendar =   Calendar(identifier: .gregorian)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//        let strDate = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//        guard let newDate = dateFormatter.date(from: strDate) else { return   nil}
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.calendar = currentCalendar
//        //dateFormatter.timeZone =  TimeZone(identifier: "UTC")!
//        let finalDateString = dateFormatter.string(from: newDate)
//        let today = Date()
//        let modifiedDate = Calendar.current.date(byAdding: .day, value: 0, to: today)!
//        let modifiedDateString = dateFormatter.string(from: modifiedDate)
//        if(finalDateString == modifiedDateString){
//            return UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
//        }
//        return UIColor.white
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        print(date)
//        let currentCalendar =   Calendar(identifier: .gregorian)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//        let strDate = dateFormatter.string(from: date)
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
//        guard let newDate = dateFormatter.date(from: strDate) else { return nil }
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.calendar = currentCalendar
//        //        dateFormatter.timeZone =  TimeZone(identifier: "UTC")!
//        let finalDateString = dateFormatter.string(from: newDate)
//        let currentDateString =  dateFormatter.string(from: Date())
//
//        for i in 0..<self.deliveryAvailabelDates.count {
//            let deliveryDate = self.deliveryAvailabelDates[i]
//
//            if(deliveryDate == finalDateString) {
//                if(finalDateString == currentDateString){
//                    return UIColor.lightGray
//                }
//                return UIColor.black
//            }
//        }
//        if(finalDateString == currentDateString){
//            return UIColor.lightGray
//        }
//        return UIColor.lightGray
//
//    }
//
//}
//
////MARK: -> Customized month and week day color
//extension FSCalendar {
//    func customizeCalenderAppearance() {
//        self.appearance.headerTitleColor = UIColor.black
//        self.appearance.weekdayTextColor  = UIColor.black
//    }
//}
//
//
//
//





//********///


import FSCalendar
class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UIGestureRecognizerDelegate {
    
    //MARK: - Properties
    @IBOutlet var viewOuterCalendar: UIView!
    @IBOutlet var viewCalendar: FSCalendar!
    @IBOutlet var closeButton: UIButton!
    
    //MARK: - Properties
    var delegate:CalendarDelegate!
    var deliveryAvailableDays:GetDeliveryAvailableData?
    var deliveryAvailabelDates = [String]()
    
    var selectedDate: Date?
    let currentCalendar = Calendar(identifier: .gregorian)
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        //deliveryAvailabelDates.remove(at: 0)
        //        deliveryAvailabelDates.append("2024-06-07")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(UserDefaults.standard.string(forKey: "test_date") as Any)
        if let selectDate  = UserDefaults.standard.string(forKey: "test_date") as? String {
            print(selectDate)
            let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy"
           let formattedselectedDate = dateFormatter.date(from: selectDate) ?? Date()
           print(formattedselectedDate)
            if formattedselectedDate >= viewCalendar.minimumDate {
                viewCalendar.select(formattedselectedDate)
            }
        }
    }
    
    func configureUI() {
        viewCalendar.customizeCalenderAppearance()
        viewCalendar.delegate = self
        viewCalendar.dataSource = self
        viewCalendar.reloadData()
        
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.black.cgColor
        closeButton.layer.cornerRadius = 5
        
        //viewCalendar
        viewCalendar.backgroundColor = UIColor.white
        viewCalendar.backgroundColor = UIColor.white
        //ViewOuterCalendar
        viewOuterCalendar.layer.borderWidth = 1
        viewOuterCalendar.layer.borderColor = UIColor.black.cgColor
        viewOuterCalendar.layer.cornerRadius = 0.0
        viewOuterCalendar.clipsToBounds = true
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //    @IBAction func doneButton(_ sender: UIButton) {
    //        self.dismiss(animated: false, completion: nil)
    //    }
    
    //MARK: - FSCalendar Delegates and DataSource
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let currentCalendar =   Calendar(identifier: .gregorian)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        let strDate = dateFormatterGet.string(from: date)
        dateFormatterGet.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        
        guard let newDate = dateFormatterGet.date(from: strDate) else { return  }
        dateFormatterGet.dateFormat = "dd/MM/yyyy"
        dateFormatterGet.calendar = currentCalendar
        //dateFormatterGet.timeZone =  TimeZone(identifier: "UTC")!
        let finalDateString = dateFormatterGet.string(from: newDate)
        delegate.passDate(strDate: finalDateString)
        UserDefaults.standard.setValue(finalDateString, forKey: "test_date")
        print(finalDateString)
        self.dismiss(animated: false, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let currentCalendar =   Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        let strDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        guard let newDate = dateFormatter.date(from: strDate) else { return  false}
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = currentCalendar
        //        dateFormatter.timeZone =  TimeZone(identifier: "UTC")!
        let finalDateString = dateFormatter.string(from: newDate)
        
        for i in 0..<self.deliveryAvailabelDates.count {
            let deliveryDate = self.deliveryAvailabelDates[i]
            if(deliveryDate == finalDateString) {
                return true
            }
        }
        return false
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let today = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 0, to: today)!
        return modifiedDate
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let currentCalendar =   Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        let strDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        guard let newDate = dateFormatter.date(from: strDate) else { return   nil}
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = currentCalendar
        //dateFormatter.timeZone =  TimeZone(identifier: "UTC")!
        let finalDateString = dateFormatter.string(from: newDate)
        let today = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 0, to: today)!
        let modifiedDateString = dateFormatter.string(from: modifiedDate)
        if(finalDateString == modifiedDateString){
            //            return UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            //            if deliveryAvailabelDates.contains(modifiedDateString) {
            //                return UIColor.init(red: 197.0/255, green: 29.0/255, blue: 34.0/255, alpha: 1.0)
            //            } else {
            //                return UIColor.gray
            //            }
            return UIColor.clear
        }
        //        return UIColor.white
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        print(date)
        let currentCalendar =   Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        let strDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        guard let newDate = dateFormatter.date(from: strDate) else { return nil }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = currentCalendar
        //        dateFormatter.timeZone =  TimeZone(identifier: "UTC")!
        let finalDateString = dateFormatter.string(from: newDate)
        let currentDateString =  dateFormatter.string(from: Date())
        
        for i in 0..<self.deliveryAvailabelDates.count {
            let deliveryDate = self.deliveryAvailabelDates[i]
            if(deliveryDate == finalDateString) {
                if(finalDateString == currentDateString){
                    //return UIColor.lightGray
                    if deliveryAvailabelDates.contains(currentDateString) {
                        return AppColors.tealColor
                    } else {
                        return AppColors.lightTealColor
                    }
                    //return AppColors.tealColor
                }
                return UIColor.black
            }
        }
        if(finalDateString == currentDateString){
            print("02")
            return AppColors.lightTealColor
            //            return AppColors.tealColor
        }
        return UIColor.lightGray
        
    }
    
    // FSCalendarDelegateAppearance method to set the fill color for selected dates
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let currentCalendar =   Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        let strDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss  yyyy"
        guard let newDate = dateFormatter.date(from: strDate) else { return nil }
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = currentCalendar
        //        dateFormatter.timeZone =  TimeZone(identifier: "UTC")!
        let finalDateString = dateFormatter.string(from: newDate)
        let currentDateString =  dateFormatter.string(from: Date())
        
        if(finalDateString == currentDateString){
            return AppColors.tealColor
        } else {
            return .lightGray
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .white
    }
    
//    private func isValid(date: Date) -> Bool {
//           let minDate = minimumDate(for: viewCalendar)
//           let maxDate = maximumDate(for: viewCalendar)
//           return (date >= minDate) && (date <= maxDate)
//       }
}

//MARK: -> Customized month and week day color
extension FSCalendar {
    func customizeCalenderAppearance() {
        self.appearance.headerTitleColor = UIColor.black
        self.appearance.weekdayTextColor  = UIColor.black
        self.appearance.headerTitleFont = UIFont(name:fontName.N_SemiBoldFont.rawValue, size: 15.0)
        self.appearance.weekdayFont = UIFont(name:fontName.N_SemiBoldFont.rawValue, size: 13.0)
        self.appearance.titleFont = UIFont(name:fontName.N_SemiBoldFont.rawValue, size: 12.0)
    }
}
