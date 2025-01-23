//
//  MyListProductTableViewCell.swift
//  GenericWholeSaleV3
//
//  Created by Sazid Saifi on 21/04/23.
//

import UIKit

class MyListProductTableViewCell: UITableViewCell {
    
    //MARK: -> Outlet’s
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: -> Properties
    var arrayOfAllProducts = [SpecialItemsData]()
    var getProductClickIndex: GetProductClickIndex?
    
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
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureData(data: [SpecialItemsData]) {
        self.arrayOfAllProducts = data
        
        collectionView.reloadData()
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "SpecialProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SpecialProductsCollectionViewCell")
    }
    
    //MARK: -> Button Actions
}


//MARK: -> UICollectionViewDelegate, UICollectionViewDataSource
extension MyListProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAllProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialProductsCollectionViewCell", for: indexPath) as! SpecialProductsCollectionViewCell
        //cell.configureProductListData(data: arrayOfAllProducts[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let getProductClickIndex =  getProductClickIndex {
            getProductClickIndex.getIndex(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (collectionView.frame.size.width) / 2, height: 208)
    }
}
