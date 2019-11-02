//
//  ViewController.swift
//  cognitive app
//
//  Created by LiQi on 2/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var itemTableView: UITableView!
    
    //protocal stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count //TODO
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemList[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell{
            cell.update(item: item)
            cell.detail.addTarget(self, action: #selector(ViewController.pressDetail(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func pressDetail(_ sender: Any?) {
        let cell = sender as! UIButton
        //print(cell.tag)
        //perform segue
        performSegue(withIdentifier: "toDetailSegue", sender: sender)
    }
    
    //view hook
    override func viewDidLoad() {
        super.viewDidLoad()
         
        itemTableView.delegate = self
        itemTableView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailSegueTo = segue.destination as? DetailViewController{
            //let index = (itemTableView.indexPathForSelectedRow?.row ?? 0) + 1
            let button = sender as? UIButton
            let index = button!.tag
            detailSegueTo.itemID = index
        }
    }
}

