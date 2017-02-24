//
//  Extensions.swift
//  AW
//
//  Created by Akhil Waghmare on 12/14/16.
//  Copyright © 2016 AW Labs. All rights reserved.
//

import UIKit
import Alamofire

extension UIView {
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadFeaturedMediaWithNumber(featuredMediaNumber: Int) {
        let fetchMediaInfoUrl = "http://awlabs.technology/blog/wp-json/wp/v2/media/\(featuredMediaNumber)"
        Alamofire.request(fetchMediaInfoUrl).responseJSON { (response) in
            if let json = response.result.value {
                let encodedMediaLink = ((json as! AnyObject).value(forKey: "guid") as AnyObject).value(forKey: "rendered") as! String
                let imageUrl = encodedMediaLink.decodeEnt()
                self.loadImageUsingCacheWithUrlString(urlString: imageUrl)
            }
        }
    }
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            
        }).resume()
    }
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension String {
    func decodeEnt() -> String{
        let encodedData = self.data(using: .utf8)
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
            NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject
        ]
        do {
            let attributedString = try NSAttributedString(data: encodedData!, options: attributedOptions, documentAttributes: nil)
            return attributedString.string
        } catch {
            print(error)
        }
        
        return ""
    }
}
