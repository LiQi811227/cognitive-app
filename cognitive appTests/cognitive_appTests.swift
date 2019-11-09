//
//  cognitive_appTests.swift
//  cognitive appTests
//
//  Created by LiQi on 8/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import XCTest
@testable import cognitive_app

class cognitive_appTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        itemList = [
            Item(id:1,date: Date(), image: "jodan.jpg", wordFrom: "Jodan", wordTo: "乔丹", soundFrom: "", soundTo: ""),
            Item(id:2,date: Date(), image: "james.jpg", wordFrom: "James", wordTo: "詹姆士", soundFrom: "", soundTo: ""),
            Item(id:3,date: Date(), image: "kury.jpg", wordFrom: "Kury", wordTo: "库里", soundFrom: "", soundTo: "")
        ]
        
        wirteData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        clearData()
    }

    func testReadData() {
        //Given
        print("------------testReadData-------------")
        //When
        let list:[Any] = readData() as! [Any]
        print(list.count)
        //Then
        XCTAssert(list.count==3,"Sandbox does not have the expected number of items!")
    }

    func testWirteData() {
        //Given
        clearData()
        //When
        wirteData()

        //Then
        let list:[Any] = readData() as! [Any]
        XCTAssert(list.count==3,"Sandbox does not have the expected number of items!")
    }

    func testAddItem() {
        //Given
        var itemWillBeAdded = Item(id:5,date: Date(), image: "jodan.jpg", wordFrom: "Jodan", wordTo: "乔丹", soundFrom: "", soundTo: "")

        //When
        addItem(itemWillBeAdded)

        //Then
        let list:[Any] = readData() as! [Any]
        XCTAssert(list.count==4,"Sandbox does not have the expected number of items!")
    }
    
    func testClearData() {
        //Given
        
        //When
        clearData()

        //Then
        XCTAssert(FileManager.default.fileExists(atPath: archiveURL.path)==false,"Plist file is not being deleted!")
    }
    
//    func testDisplay() {
//        //Given
//        let detailScreen = DetailViewController()
//
//        //When
//        //detailScreen.viewDidLoad()
//        detailScreen.display(1)
//
//        //Then
//        XCTAssert(detailScreen.wordFrom.text=="Jodan","Wrong wordFrom!")
//    }
    
    func testSaveImageToSandBox() {
        //Given
        guard let image = UIImage(named:"Jodan.jpg") else { return }
        
        //When
        saveImageToSandBox("Jodantest",image)

        //Then
        
        XCTAssert(FileManager.default.fileExists(atPath: getImageFromSandBox(fileName:"Jodantest"))==true,"Wrong image saving!")
    }
}

