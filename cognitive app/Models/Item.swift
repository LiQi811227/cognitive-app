//
//  Item.swift
//  cognitive app
//
//  Created by LiQi on 3/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import Foundation

struct Item:Codable {
    let id:Int
    let date:Date
    let image:String
    let wordFrom:String
    let wordTo:String
    let soundFrom:String
    let soundTo:String
}
