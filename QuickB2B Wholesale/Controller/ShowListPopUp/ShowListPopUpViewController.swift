import UIKit

class ShowListPopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShowListTableViewCellDelegate {
   
    //MARK: - Outlet's
    @IBOutlet weak var ListTableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    var arrayOfList = [GetItemsData]()
    var itemCode = ""
    var isChangedQuantity = false
    var refreshDelegate: RefreshDelegate?
    
    //MARK: - Life-Cycle-Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI and TableView
        cancelButton.addBorderLayer()
        ListTableView.register(UINib(nibName: "ShowListTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowListTableViewCell")
        ListTableView.delegate = self
        ListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confiqureUI()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update table view height once layout is set
        updateTableViewHeight()
    }
    
    func getFilterItem(array:[GetItemsData]) -> [GetItemsData] {
        var test = [GetItemsData]()
        for i in array {
            if i.item_code == self.itemCode {
                test.append(i)
            }
        }
       return test
    }
    
    func confiqureUI() {
        arrayOfList = getFilterItem(array: LocalStorage.getFilteredData())
        arrayOfList += getFilterItem(array: LocalStorage.getFilteredMultiData())
        if arrayOfList.count == 0 {
            itemNameLabel.text = "No Record To Show"
        } else {
            itemNameLabel.text = arrayOfList[0].item_name
        }
        // Reload table and update height constraint
        ListTableView.reloadData()
        updateTableViewHeight()
    }
    
   
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view.endEditing(true)
        self.refreshDelegate?.refresh()
        self.dismiss(animated: false)
    }
    
    //MARK: - TableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowListTableViewCell") as! ShowListTableViewCell
        cell.delegate = self
        cell.measureLabel.delegate = self
        cell.orginQuantityLabel.delegate = self
        cell.confiqureUI(itemData: arrayOfList[indexPath.row], showAddView: indexPath.row == arrayOfList.count - 1)
        return cell
    }
    
    
    
    //MARK: - Helper Method to Update TableView Height
    private func updateTableViewHeight() {
        tableViewHeightConstraint.constant = ListTableView.contentSize.height
        self.view.layoutIfNeeded() // Ensure the layout is updated
    }
    
    
    func addButtonTapped() {
        var item = arrayOfList[arrayOfList.count - 1]
        if item.originQty == "" || item.quantity == "" || item.measureQty == "" {
            return
        }
       
        item.originQty = ""
        item.quantity = ""
        item.measureQty = ""
        arrayOfList.append(item)
        self.ListTableView.reloadData()
        updateTableViewHeight()
        self.ListTableView.scrollToRow(at: IndexPath(row: arrayOfList.count-1, section: 0), at: .bottom, animated: true)

        
    }
}


//MARK: -> UITextFieldDelegate
extension ShowListPopUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cell = getCell(for: textField) {
            if let measureTextField = cell.measureLabel.text, let quantityTextField = cell.orginQuantityLabel.text {
                if quantityTextField != "" && measureTextField != "" && quantityTextField != "0" && quantityTextField != "0.0" && quantityTextField != "0.00" && measureTextField != "0" && measureTextField != "0.0" && measureTextField != "0.00" {
                    print(cell.measureLabel.text ?? "")
                    print(cell.orginQuantityLabel.text ?? "")
                    var mutatedItem = arrayOfList[arrayOfList.count - 1]
                    mutatedItem.originQty = quantityTextField
                    mutatedItem.measureQty = measureTextField
                    let floatQuantity = (mutatedItem.measureQty!  as NSString).floatValue.clean
                    let strQuantity = String(floatQuantity)
                    
                    let floatOriginQty = (mutatedItem.originQty! as NSString).floatValue.clean
                    let strOriginQty = String(floatOriginQty)
                    
                    if let quan = Double(strOriginQty), let measureQty = Double(strQuantity) {
                        let totalQuantity = quan * measureQty
                        var quantity = "\(totalQuantity)"
                        mutatedItem.quantity = quantity // Modify the mutable copy
                    } else {
                        print("Invalid values for quantity or measureQty")
                    }
                    
                    if mutatedItem.originQty != "0" && mutatedItem.originQty != "0.0" && mutatedItem.originQty != "0.00" && mutatedItem.measureQty != "0" && mutatedItem.measureQty != "0.0" && mutatedItem.measureQty != "0.00" && mutatedItem.originQty != "" && mutatedItem.measureQty != "" && mutatedItem.originQty != ".00" && mutatedItem.measureQty != ".00" && mutatedItem.originQty != ".0" && mutatedItem.measureQty != ".0" {
                        mutatedItem.priority = 0
                        mutatedItem.id = 0
                        var data = LocalStorage.getShowItData()
                        data.append(mutatedItem)
                        LocalStorage.saveMultiData(data: data)
                        confiqureUI()
                      
                        
                    }
                    
                }
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // Combine the current text with the replacement text
        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)
        // Regular expression to match the allowed format
        let regex = try! NSRegularExpression(pattern: "^\\d{0,4}(\\.\\d{0,2})?$")
        let range = NSRange(location: 0, length: updatedText.utf16.count)
        if regex.firstMatch(in: updatedText, options: [], range: range) == nil {
            return false // Don't allow the change
        }
        return true
    }
    
    func getCell(for textField: UITextField) -> ShowListTableViewCell? {
        var view: UIView? = textField
        while let superview = view?.superview {
            if let cell = superview as? ShowListTableViewCell {
                return cell
            }
            view = superview
        }
        return nil
    }
    
}
