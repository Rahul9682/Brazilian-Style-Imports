//  SocialLinksCell.swift
//  QuickB2B Wholesale
//  Created by Brain Tech on 5/19/21.

import UIKit


class SocialLinksCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    //MARK:- Properties
    var delegate:OpenUrlDelegate!
    var arrLinks = [GetLinksData]()
    @IBOutlet var socialLinksCollectionView: UICollectionView!
    
    //MARK:- LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        socialLinksCollectionView.delegate = self
        socialLinksCollectionView.dataSource = self
        self.socialLinksCollectionView.register(UINib(nibName: "SocialLinksCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SocialLinksCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialLinksCollectionViewCell", for: indexPath) as! SocialLinksCollectionViewCell
        if  let socialLink = self.arrLinks[indexPath.row].type {
            if (socialLink == "FACEBOOK") {
                cell.socialLinksImageView.image = #imageLiteral(resourceName: "linkFacebook")
            } else if (socialLink == "INSTAGRAM") {
                cell.socialLinksImageView.image = #imageLiteral(resourceName: "linkInstagram")
            } else if (socialLink == "LINKEDIN") {
                cell.socialLinksImageView.image = #imageLiteral(resourceName: "linkLinkedin")
            } else if (socialLink == "TWITTER") {
                cell.socialLinksImageView.image = #imageLiteral(resourceName: "linkTwitter")
            } else if (socialLink == "PINTEREST") {
                cell.socialLinksImageView.image = #imageLiteral(resourceName: "linkPinInterest")
            } else if (socialLink == "YOUTUBE") {
                cell.socialLinksImageView.image = #imageLiteral(resourceName: "linkYoutube")
            }
            else {//google
                cell.socialLinksImageView.image = #imageLiteral(resourceName: "linkGoogle")
            }
            return cell;
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if  let strUrlLink = arrLinks[indexPath.row].link {
        delegate.openUrl(url: strUrlLink)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:socialLinksCollectionView.frame.size.width/2-15, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
