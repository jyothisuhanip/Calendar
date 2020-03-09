//
//  Event.swift
//  Calendar
//
//  Created by Jyothi Suhani on 29/02/20.
//  Copyright © 2020 Jyothi Suhani. All rights reserved.
//

import UIKit

class Event: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
