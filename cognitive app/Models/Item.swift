//
//  Item.swift
//  cognitive app
//
//  Created by LiQi on 3/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import Foundation

struct Item:Codable {
    var id:Int
    var date:Date
    var image:String
    var wordFrom:String
    var wordTo:String
    var soundFrom:String
    var soundTo:String
}
