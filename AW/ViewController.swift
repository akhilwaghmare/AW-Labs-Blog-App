//
//  ViewController.swift
//  AW
//
//  Created by Akhil Waghmare on 12/14/16.
//  Copyright © 2016 AW Labs. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var posts: [Post] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "AW Labs"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        view.addSubview(collectionView)
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchPosts()
    }
    
    func fetchPosts() {
        let fetchUrl = "http://awlabs.technology/blog/wp-json/wp/v2/posts"
        Alamofire.request(fetchUrl).responseJSON { (response) in
            if let json = response.result.value {
//                print("JSON: \(json)")
                self.parseJSON(json: json)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func parseJSON(json: Any) {
        posts.removeAll()
        var list: [Post] = []
        if json is Array<AnyObject> {
            for object in json as! [AnyObject] {
                let titleInfo = object.value(forKey: "title") as AnyObject
                let encodedTitle = titleInfo.value(forKey: "rendered") as! String
                let title = encodedTitle.decodeEnt()
                
                let featuredMediaNumber = object.value(forKey: "featured_media") as! Int
                let newPost = Post(title: title, featuredMediaNumber: featuredMediaNumber, date: Date())
                self.posts.append(newPost)
            }
        }
    }
    
    func parseMediaJSON(json: Any) {
        
    }
    
    let cellId = "cellId"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


}

