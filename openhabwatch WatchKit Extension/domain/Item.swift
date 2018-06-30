//
//  Item.swift
//  openhabwatch WatchKit Extension
//
//  Created by Dirk Hermanns on 31.05.18.
//  Copyright © 2018 private. All rights reserved.
//

import Foundation

class Item : NSObject, NSCoding {
    
    let name : String
    let label : String
    
    init(name : String, label : String) {
        self.name = name
        self.label = label
    }
    
    // serializer
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.label = decoder.decodeObject(forKey: "label") as! String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(label, forKey: "label")
    }
}
