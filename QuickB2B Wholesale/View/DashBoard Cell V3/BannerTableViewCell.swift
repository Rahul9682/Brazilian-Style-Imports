//  BannerTableViewCell.swift
//  Luxury Car
//  Created by Sazid Saifi on 5/4/22.

import UIKit

class BannerTableViewCell: UITableViewCell {
    
    //MARK: -> Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControlContainerView: UIView!
    // @IBOutlet weak var pageController: UIPageControl!//CustomPageControl!
    @IBOutlet weak var pageController: CustomPageControl!
    
    //MARK: -> Properties
    var arrayOfBannerData = [BannerList]()
    var currentPage = 0
    var delegeteBannerImageClick: DelegeteBannerImageClick?
    var timer = Timer()
    var counter = 0
    
    var isTest = false
    var arrayOfBannerTest = ["banner1","banner2","banner3"]
    
    //MARK: -> LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        startTimer() //for stop auto scroll
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: -> Helpers
    func configureUI() {
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if isTest {
            pageController.numberOfPages = arrayOfBannerTest.count
        } else {
            pageController.numberOfPages = arrayOfBannerData.count
        }
    }
    
    func registerCell() {
        collectionView.register(UINib(nibName: "BannerImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerImageCollectionViewCell")
    }
    
    func configureUI(with data: [BannerList]) {
        self.arrayOfBannerData = data
        collectionView.reloadData()
        configureUI()
    }
    
    //MARK: -> Button Actions
}

//MARK: -> UICollectionViewDelegate & UICollectionViewDataSource
extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isTest {
            return arrayOfBannerTest.count
        } else {
            return arrayOfBannerData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCollectionViewCell", for: indexPath) as! BannerImageCollectionViewCell
        if isTest {
            cell.configureTest(img: arrayOfBannerTest[indexPath.row])
        } else {
            cell.configureData(data: arrayOfBannerData[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isTest {
            
        } else {
            if let delegeteBannerImageClick = delegeteBannerImageClick {
                delegeteBannerImageClick.didClickBannerImage(ind: indexPath.row)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: Constants.bannerHeight)
    }
}

//MARK: UIScrollViewDelegate
extension BannerTableViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset , size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageController.currentPage = visibleIndexPath.row
        }
    }
}

//MARK: Auto-Scroll Banner
extension BannerTableViewCell {
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        for cell in collectionView.visibleCells {
            if isTest {
                if arrayOfBannerTest.count == 1 {
                    return
                }
                let indexPath = collectionView.indexPath(for: cell)!
                if indexPath.row < (arrayOfBannerTest.count - 1) {
                    let indexPath1 = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                    collectionView.scrollToItem(at: indexPath1, at: .right, animated: true)
                    pageController.currentPage = indexPath1.row
                }
                else {
                    let indexPath1 = IndexPath.init(row: 0, section: indexPath.section)
                    collectionView.scrollToItem(at: indexPath1, at: .left, animated: true)
                    pageController.currentPage = indexPath1.row
                }
            } else {
                if arrayOfBannerData.count == 1 {
                    return
                }
                let indexPath = collectionView.indexPath(for: cell)!
                if indexPath.row < (arrayOfBannerData.count - 1) {
                    let indexPath1 = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                    collectionView.scrollToItem(at: indexPath1, at: .right, animated: true)
                    pageController.currentPage = indexPath1.row
                }
                else {
                    let indexPath1 = IndexPath.init(row: 0, section: indexPath.section)
                    collectionView.scrollToItem(at: indexPath1, at: .left, animated: true)
                    pageController.currentPage = indexPath1.row
                }
            }
        }
    }
}
