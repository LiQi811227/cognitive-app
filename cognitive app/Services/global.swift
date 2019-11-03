//
//  global.swift
//  cognitive app
//
//  Created by LiQi on 3/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import Foundation
import UIKit

//TODO:Initialise the Moke data(images and items)
public let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//print(documentsDirectory)
//items plist
public let archiveURL = documentsDirectory.appendingPathComponent("cognitiveapp").appendingPathExtension("plist")

public var encodedItems:(Any)? = nil
public func wirteData(){
    let propertyListEncoder = PropertyListEncoder()
    if let encodedItemList = try? propertyListEncoder.encode(itemList) {
        encodedItems = encodedItemList
        //print(encodedItemList)
    }
}
public func readData()->Any?{
    let propertyListDecoder = PropertyListDecoder()
    if let decodedItemList = try?
        propertyListDecoder.decode([Item].self, from: encodedItems as! Data) {
        //print(decodedItemList)
        return decodedItemList
    }
    return nil
}

let fullPath = NSHomeDirectory().appending("/Documents/")

public func saveImageToSandBox(){
    var imgName:String=""
    for item in itemList {
        imgName = item.image
        let imgTmp: UIImage = UIImage(named: imgName)!
        if let imageData = imgTmp.jpegData(compressionQuality: 1) as NSData? {
            let imgPath = fullPath.appending(imgName)
            imageData.write(toFile: imgPath, atomically: true)
            print("imgPath=\(imgPath)")
        }
    }
}
public func getImageFromSandBox(fileName:String)->String{
    return fullPath.appending(fileName)
}
