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

//items plist
public let archiveURL = documentsDirectory.appendingPathComponent("cognitiveapp").appendingPathExtension("plist")
let propertyListEncoder = PropertyListEncoder()

public var encodedItems:(Any)? = nil
public func wirteData(){
//    let propertyListEncoder = PropertyListEncoder()
    print("--------writeData----------")
    if let encodedItemList = try? propertyListEncoder.encode(itemList) {
        
        try? encodedItemList.write(to: archiveURL,options: .noFileProtection)
        
        encodedItems = encodedItemList
        print(archiveURL)
    }
}

public func clearData(){
    print("--------clearData----------")
    do {
        if FileManager.default.fileExists(atPath: archiveURL.path) {
            try FileManager.default.removeItem(atPath: archiveURL.path)
        }
    } catch {
        print(error)
    }
}

public func readData()->Any?{
    let propertyListDecoder = PropertyListDecoder()
    
    if let decodedItemList = try?
        propertyListDecoder.decode([Item].self, from:try! Data(contentsOf: archiveURL)) {
        print(decodedItemList)
        return decodedItemList
    }
    return nil
}

public func addItem(_ item:Any){
    if var i = item as? Item {
        i.id = itemList.count+1
        i.date = Date()
        itemList.append(i)
        wirteData()
    }
}

let fullPath = NSHomeDirectory().appending("/Documents/")

public func saveImageToSandBox(){
    var imgName:String=""
    for item in itemList {
        imgName = item.image
        let imgTmp: UIImage = UIImage(named: imgName)!
        if let imageData = imgTmp.jpegData(compressionQuality: 0.2) as NSData? {
            let imgPath = fullPath.appending(imgName)
            imageData.write(toFile: imgPath, atomically: true)
            print("imgPath=\(imgPath)")
        }
    }
}

public func saveImageToSandBox(_ imgName:String, _ image:UIImage){
    if let imageData = image.jpegData(compressionQuality: 0.2) as NSData? {
        let imgPath = fullPath.appending(imgName)
        imageData.write(toFile: imgPath, atomically: true)
        print("imgPath=\(imgPath)")
    }
}

public func getImageFromSandBox(fileName:String)->String{
    return fullPath.appending(fileName)
}

