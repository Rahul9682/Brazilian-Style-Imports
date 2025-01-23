//  CustomPageControl.swift
//  Luxury Car
//  Created by Sazid Saifi on 5/5/22.

import UIKit

class CustomPageControl: UIStackView {
    
    //MARK: -> Properties
    @IBInspectable var currentPageImage: UIImage = Icons.yellowDot!
    @IBInspectable var pageImage: UIImage = Icons.whiteDot!
    
    var numberOfPages = 3 {
        didSet {
            layoutIndicators()
        }
    }
    
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }
    
    //MARK: -> life-Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        axis = .horizontal
        distribution = .equalSpacing
        spacing  = 8
        alignment = .center
        layoutIndicators()
    }
    
    //MARK: -> Helpers
    private func layoutIndicators() {
        
        for i in 0..<numberOfPages {
            var imageView: UIImageView
            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! UIImageView // reuse subview if possible
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
            }
            
            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
        
        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }
    
    private func setCurrentPageIndicator() {
        for i in 0..<arrangedSubviews.count {
           var imageView = arrangedSubviews[i] as! UIImageView
            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}

class SourcingPageControl: UIStackView {
    
    //MARK: -> Properties
    @IBInspectable var currentPageImage: UIImage = Icons.greenDot!
    @IBInspectable var pageImage: UIImage = Icons.blackDot!
    
    var numberOfPages = 3 {
        didSet {
            layoutIndicators()
        }
    }
    
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }
    
    //MARK: -> life-Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        axis = .horizontal
        distribution = .equalSpacing
        spacing  = 8
        alignment = .center
        layoutIndicators()
    }
    
    //MARK: -> Helpers
    private func layoutIndicators() {
        
        for i in 0..<numberOfPages {
            let imageView: UIImageView
            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! UIImageView // reuse subview if possible
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
            }
            
            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
        
        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }
    
    private func setCurrentPageIndicator() {
        for i in 0..<arrangedSubviews.count {
            let imageView = arrangedSubviews[i] as! UIImageView
            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}
