//
//  CategoriesTableViewCell.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 19/04/23.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: -> Properties
    var arrayOfCategories = [AllCategory]()
    var delegeteProductClick: DelegeteProductClick?
    
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
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "HomeCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoriesCollectionViewCell")
    }
    
    func configureData(data: [AllCategory]) {
        self.arrayOfCategories = data
        self.collectionView.reloadData()
    }
    
    //MARK: -> Button Actions
}

//MARK: -> UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CategoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoriesCollectionViewCell", for: indexPath) as! HomeCategoriesCollectionViewCell
        cell.configureUI()
        cell.configureData(data: arrayOfCategories[indexPath.row])
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegeteProductClick = delegeteProductClick {
            delegeteProductClick.didClickProduct(index: indexPath.row, listingType: .searchByCategory)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 114, height: 120)
        return CGSize(width:152, height: 139)
    }
    
    //Spacing B/w Cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
