//
//  DetailViewController.swift
//  cognitive app
//
//  Created by LiQi on 3/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var wordFrom: UILabel!
    @IBOutlet weak var wordTo: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    //speech action
    @IBAction func speechAction(_ sender: UIButton) {
        speech(wordFrom.text)
    }
    
    @IBAction func speechAction2(_ sender: UIButton) {
        speech(wordTo.text)
    }
    
    var segueSource:String = "list"
    var itemID:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if segueSource=="list" {
            print("From List page, itemID:\(itemID)")
            
            // display detail
            display(itemID)
        }else{
            print("From Photo take page, itemID:\(itemID)")
            
            // display detail
            display(itemID)
        }
    }
    
    private func display(_ itemID:Int){
        
        let itemList:[Item]? = readData() as? [Item]
        
        let item = itemList?.first(where:{$0.id==itemID})
        
        print(item ?? "nothing getted.")
        
        wordFrom.text = item?.wordFrom
        wordTo.text = item?.wordTo
        
        //TODO:display image getting from maskdomain
        let imgPathFromSandBox:String = getImageFromSandBox(fileName:item?.image ?? "jodan.jpg")
        let img: UIImage = UIImage(contentsOfFile: imgPathFromSandBox)!
        //let img: UIImage = UIImage(named: item?.image ?? "no.jpg")!
        image.image = img
    }
    
    private func speech(_ text:String?){
        if let textForSpeech = text{
            //TODO:call remote api
            //TODO:call AVPlay
            print(textForSpeech)
        }
    }
}
