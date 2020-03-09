//
//  MonthAndYearTableViewCell.swift
//  Calendar
//
//  Created by Jyothi Suhani on 29/02/20.
//  Copyright © 2020 Jyothi Suhani. All rights reserved.
//

import UIKit
class MonthAndYear: UITableViewCell {
    var delegate: DateValue?
    var monthAndYear: DateMonthYear?
    let dateFormatter = DateFormatter()
    var completion: () -> () = {}
    @IBAction func prevButton(_ sender: UIButton) {
        monthAndYear = delegate?.getMonthAndYear()
        if let monthoryear = monthOrYearLabel.text {
            if let y = Int(monthoryear) {
                monthAndYear?.year = String(y - 1)
            } else {
                dateFormatter.dateFormat = "MMMM"
                if let date = dateFormatter.date(from: monthOrYearLabel.text ?? "") {
                    var monthIndex = Calendar.current.component(.month, from: date)
                    if monthIndex == 1 {
                        monthIndex = 12
                        monthAndYear?.year = String((Int(monthAndYear?.year ?? "") ?? 0) - 1)
                    } else {
                        monthIndex = monthIndex - 1
                    }
                    let monthName = DateFormatter().monthSymbols?[monthIndex - 1]
                    monthAndYear?.month = monthName ?? ""
                }
            }
        }
        completion()
    }
    @IBAction func nextButton(_ sender: UIButton) {
        monthAndYear = delegate?.getMonthAndYear()
        if let monthoryear = monthOrYearLabel.text {
            if let y = Int(monthoryear) {
                monthAndYear?.year = String(y + 1)
            } else {
                dateFormatter.dateFormat = "MMMM"
                if let date = dateFormatter.date(from: monthoryear) {
                    var monthIndex = Calendar.current.component(.month, from: date)
                    if monthIndex == 12 {
                        monthIndex = 1
                        monthAndYear?.year = String((Int(monthAndYear?.year ?? "") ?? 0) + 1)
                    } else {
                        monthIndex = monthIndex + 1
                    }
                    let monthName = dateFormatter.monthSymbols?[monthIndex - 1]
                    monthAndYear?.month = monthName ?? ""
                }
            }
        }
        completion()
    }
    @IBOutlet weak var monthOrYearLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
