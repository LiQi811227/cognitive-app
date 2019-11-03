//
//  DescribeImage.swift
//  cognitive app
//
//  Created by LiQi on 3/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import Foundation

struct DescribeImage: Codable {
    let description: Description?
    let requestId: String?
}

struct Description: Codable {
    let tags: [String]?
    let captions: [Caption]?
}

struct Caption: Codable {
    let text: String?
    let confidence: Float?
}
