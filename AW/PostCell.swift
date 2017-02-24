//
//  PostCell.swift
//  AW
//
//  Created by Akhil Waghmare on 12/14/16.
//  Copyright © 2016 AW Labs. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard post != nil else {
                return
            }
            imageView.loadFeaturedMediaWithNumber(featuredMediaNumber: (post?.featuredMediaNumber)!)
            titleLabel.text = post?.title
            dateLabel.text = post?.date?.description
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .yellow
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Post Title. Hi my name is Akhil and this ia very, very, very long article title. I hope you like this very amazing application which I built."
        label.textColor = .white
        label.numberOfLines = 4
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Post Date"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(separatorView)
        
        imageView.anchorToTop(topAnchor, left: leftAnchor, bottom: separatorView.topAnchor, right: rightAnchor)
        _ = titleLabel.anchor(nil, left: leftAnchor, bottom: dateLabel.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 8, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        _ = dateLabel.anchor(titleLabel.bottomAnchor, left: leftAnchor, bottom: separatorView.topAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = separatorView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
