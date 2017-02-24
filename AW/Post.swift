//
//  Post.swift
//  AW
//
//  Created by Akhil Waghmare on 12/14/16.
//  Copyright © 2016 AW Labs. All rights reserved.
//

import Foundation

class Post: NSObject {
    var title: String?
    var featuredMediaNumber: Int?
    var date: Date?
    
    init(title: String, featuredMediaNumber: Int, date: Date) {
        self.title = title
        self.date = date
        self.featuredMediaNumber = featuredMediaNumber
    }
}
