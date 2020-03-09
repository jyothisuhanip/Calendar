//
//  DatePickerCell.swift
//  Calendar
//
//  Created by Jyothi Suhani on 03/03/20.
//  Copyright © 2020 Jyothi Suhani. All rights reserved.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var datePickerCell: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
