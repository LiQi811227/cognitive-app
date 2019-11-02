//
//  TableViewCell.swift
//  cognitive app
//
//  Created by LiQi on 3/11/19.
//  Copyright © 2019 LiQi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var wordFrom: UILabel!
    @IBOutlet weak var wordTo: UILabel!
    @IBOutlet weak var detail: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(item:Item){
        wordFrom.text = item.wordFrom
        wordTo.text = item.wordTo
        detail.tag = item.id
    }
    
    
}
