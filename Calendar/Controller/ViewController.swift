//
//  ViewController.swift
//  Calendar
//
//  Created by Jyothi Suhani on 29/02/20.
//  Copyright © 2020 Jyothi Suhani. All rights reserved.
//

import UIKit
protocol DateValue {
    func getMonthAndYear() -> DateMonthYear
}

class ViewController: UIViewController {
    @IBOutlet weak var jumpToDateLabel: UIBarButtonItem!
//    @IBAction func jumpToDateButton(_ sender: UIBarButtonItem) {
//          datePicker = UIDatePicker.init()
//          datePicker.backgroundColor = UIColor.white
//          datePicker.autoresizingMask = .flexibleWidth
//          datePicker.datePickerMode = .date
//          datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
//          datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
//          self.view.addSubview(datePicker)
//            toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
//          toolBar.barStyle = .default
//        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
//        jumpToDateLabel.isEnabled = false
//          toolBar.sizeToFit()
//          self.view.addSubview(toolBar)
//    }
    @IBOutlet weak var calendarTable: UITableView!
    var date: Date = Date()
    var headerView: CalendarCollectionView = CalendarCollectionView()
    var monthAndYear: DateMonthYear = DateMonthYear()
    var index: Int?
    var event: EventOfDay = EventOfDay()
    var datePicker: UIDatePicker = UIDatePicker()
    var toolBar: UIToolbar = UIToolbar()
    override func viewDidLoad() {
        super.viewDidLoad()
        let monthAndYearNib = UINib.init(nibName: "MonthAndYear", bundle: nil)
        calendarTable.register(monthAndYearNib, forCellReuseIdentifier: "MonthAndYear")
        let calendarCollectionNib = UINib.init(nibName: "CalendarCollectionView", bundle: nil)
        calendarTable.register(calendarCollectionNib, forHeaderFooterViewReuseIdentifier: "CalendarCollectionView")
        let eventNib = UINib.init(nibName: "Event", bundle: nil)
        calendarTable.register(eventNib, forCellReuseIdentifier: "Event")
        let datePickerNib = UINib.init(nibName: "DatePickerCell", bundle: nil)
        calendarTable.register(datePickerNib, forCellReuseIdentifier: "DatePickerCell")
        calendarTable.dataSource = self
        calendarTable.delegate = self
        monthAndYear.month = date.month
        monthAndYear.year = date.year
        monthAndYear.day = date.day
        readEventsFromFile()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.headerView.calendarCollection.reloadData()
    }
    
    func readEventsFromFile() {
        if let path = Bundle.main.path(forResource: "EventsFile", ofType: "json") {
            let eventUrl = URL(fileURLWithPath: path)
            if let eventData = try? Data(contentsOf: eventUrl, options: .mappedIfSafe) {
                event = try! JSONDecoder().decode(EventOfDay.self, from: eventData)
            }
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        if let date = sender?.date {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
            monthAndYear.day = String(dateComponents.day ?? 0)
            monthAndYear.month = DateFormatter().monthSymbols[(dateComponents.month ?? 0) - 1]
            monthAndYear.year = String(dateComponents.year ?? 0)
            monthAndYear.isSelected = true
            self.headerView.calendarCollection.reloadData()
            self.calendarTable.reloadData()
        }
    }
}


extension Date {
    var month: String {
        let date = Foundation.Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
    var year: String {
        let date = Foundation.Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    var day: String {
        let date = Foundation.Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var returnValue: UIView?
        if let sections: Sections = Sections(rawValue: section) {
            switch sections {
            case .changeMonthAndYear:
                returnValue = nil
            case .calendar:
                if let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CalendarCollectionView") as? CalendarCollectionView {
                    headerCell.delegate = self
                    headerView = headerCell
                    headerCell.completion = {
                        self.calendarTable.reloadData()
                    }
                    returnValue = headerCell
                }
            case .datePicker:
                returnValue = nil
            }
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 2 {
            return 0
        }
        return (UIScreen.main.bounds.width) - (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0) - (UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        monthAndYear.isSelected = false
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue: Int = 1
        if let sections: Sections = Sections(rawValue: section) {
            switch sections {
            case .changeMonthAndYear:
                returnValue = 2
            case .calendar:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM"
                let dateFromMonth = dateFormatter.date(from: monthAndYear.month)
                let monthIndex = Calendar.current.component(.month, from: dateFromMonth!)
                if let eventsCount = event.reminders?.count {
                    index = nil
                    for i in 0...eventsCount - 1 {
                        if Int(monthAndYear.day) == self.event.reminders?[i].day && self.event.reminders?[i].year == Int(monthAndYear.year) && self.event.reminders?[i].month == monthIndex  {
                            returnValue = event.reminders?[i].events.count ?? 0
                            index = i
                        }
                    }
                }
            case .datePicker:
                returnValue = 1
            }
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnValue = UITableViewCell()
        if let sections: Sections = Sections(rawValue: indexPath.section) {
            switch sections {
            case .changeMonthAndYear:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MonthAndYear") as? MonthAndYear {
                    cell.selectionStyle = .none
                    cell.delegate = self
                    cell.completion = {
                        self.calendarTable.reloadData()
                        self.headerView.calendarCollection.reloadData()
                    }
                    if indexPath.row  == 0 {
                        cell.monthOrYearLabel.text = self.monthAndYear.year
                    } else {
                        cell.monthOrYearLabel.text = self.monthAndYear.month
                    }
                    returnValue = cell
                }
            case .calendar:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as? Event {
                    if index != nil {
                        cell.eventLabel.text = event.reminders?[index ?? 0].events[indexPath.row]
                    } else {
                        cell.eventLabel.text = "No events for this day"
                    }
                    returnValue = cell
                }
            case .datePicker:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as? DatePickerCell {
                    cell.datePickerCell.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
                    var dateComponents = DateComponents()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM"
                    dateComponents.day = Int(monthAndYear.day)
                    let dateFromMonth = dateFormatter.date(from: monthAndYear.month ?? Date().month)
                    let monthIndex = Calendar.current.component(.month, from: dateFromMonth!)
                    dateComponents.month = monthIndex
                    dateComponents.year = Int(monthAndYear.year)
                    cell.datePickerCell.date = Calendar.current.date(from: dateComponents)!
                    returnValue = cell
                }
            }
        }
        return returnValue
    }
}

extension ViewController: DateValue {
    func getMonthAndYear() -> DateMonthYear {
        return monthAndYear
    }
}
