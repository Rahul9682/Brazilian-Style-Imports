//
//  ChipsTableViewCell.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 21/04/23.
//

import UIKit

class ChipsTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: -> Properties
    var arrayOfChips = [String]()
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        registerCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    func configureUI() {
        selectionStyle = .none
      //  collectionView.delegate = self
      ///  collectionView.dataSource = self
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "ChipsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChipsCollectionViewCell")
    }
    
//    func configureData(data: [String]) {
//        self.arrayOfChips = data
//    }
    
    //MARK: -> Button Actions
    
}


//MARK: -> UICollectionViewDelegate,UICollectionViewDataSource
//extension ChipsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return arrayOfChips.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChipsCollectionViewCell", for: indexPath) as! ChipsCollectionViewCell
//        cell.configureUI()
//        cell.configureData(chipsData: arrayOfChips[indexPath.row])
//        return  cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let string = arrayOfChips[indexPath.row]
//        let width = (string.count * 10)
//        return CGSize(width:width, height: 40)
//        //return CGSize(width: collectionView.bounds.width/2.0, height: 240)
//    }
//}
