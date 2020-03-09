//
//  CalendarCollectionView.swift
//  Calendar
//
//  Created by Jyothi Suhani on 29/02/20.
//  Copyright © 2020 Jyothi Suhani. All rights reserved.
//

import UIKit
class CalendarCollectionView: UITableViewHeaderFooterView {
    @IBOutlet weak var calendarCollection: UICollectionView!
    var days: [String] = ["S", "M", "T", "W", "T", "F", "S"]
    var delegate: DateValue?
    var completion: () -> () = {}
    var selectedCell: IndexPath?
    var monthAndYear: DateMonthYear?
    var date: Foundation.Date = Foundation.Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib.init(nibName: "DateItem", bundle: nil)
        calendarCollection.register(nib, forCellWithReuseIdentifier: "DateItem")
        calendarCollection.delegate = self
        calendarCollection.dataSource = self
    }
    
    func getDay(monthIndex: Int) -> Int {
        var dateComponents = DateComponents()
        if let year = Int((monthAndYear?.year) ?? Date().year) {
            dateComponents.year = year
            dateComponents.month = monthIndex
            if let date = Calendar.current.date(from: dateComponents) {
                let weekday = Calendar.current.component(.weekday, from: date)
                return weekday
            }
        }
        return 0
    }
    
    func getMonthIndex() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        if let month: String = monthAndYear?.month ?? Date().month {
            let dateFromMonth = dateFormatter.date(from: month)
            let monthIndex = Calendar.current.component(.month, from: dateFromMonth!)
            return monthIndex
        }
        return 0
    }
    
    func setSelectedCell() {
        if let index = selectedCell
            , let cell = calendarCollection.cellForItem(at: index) as? DateItem {
            cell.backgroundColor = .green
        }
    }
    
    func getCurrentDate() -> Foundation.Date {
        let monthIndex = getMonthIndex()
        let startDay = getDay(monthIndex: monthIndex)
        let dateComponents = DateComponents(year: Int(monthAndYear?.year ?? Date().year), month: monthIndex)
        if let date = Calendar.current.date(from: dateComponents) {
            let fullDate = Calendar.current.date(byAdding: .day, value: -startDay + 1, to: date)!
            return fullDate
        }
        return Foundation.Date()
    }
}

extension CalendarCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedCell, let cell = collectionView.cellForItem(at: index) as? DateItem {
            if cell.dateValue.month == getMonthIndex() {
                cell.backgroundColor = .white
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? DateItem {
            cell.backgroundColor = .green
            selectedCell = indexPath
            if let year = cell.dateValue.year {
                monthAndYear?.year = String(year)
            }
            monthAndYear?.month = DateFormatter().monthSymbols?[(cell.dateValue.month ?? 1) - 1] ?? ""
            if let day = cell.dateValue.day {
                monthAndYear?.day = String(day)
            }
        }
        completion()
    }
}

extension CalendarCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        monthAndYear = delegate?.getMonthAndYear()
        date = getCurrentDate()
        selectedCell = nil
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnValue = UICollectionViewCell()
        if let cell = calendarCollection.dequeueReusableCell(withReuseIdentifier: "DateItem", for: indexPath) as? DateItem {
            cell.isUserInteractionEnabled = true
            cell.backgroundColor = .white
            if indexPath.item < 7 {
                cell.dateLabel.text = days[indexPath.item]
                cell.isUserInteractionEnabled = false
            } else {
                let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: date)
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                cell.dateLabel.text = String(currentDate.day ?? 0)
                cell.dateValue = currentDate
                if currentDate.day == Int(monthAndYear?.day ?? Date().day) && currentDate.month == getMonthIndex() {
                    selectedCell = indexPath
                }
                if currentDate.month != getMonthIndex() {
                    cell.isUserInteractionEnabled = false
                    cell.backgroundColor = .gray
                }
            }
            returnValue = cell
        }
        setSelectedCell()
        return returnValue
    }
}

extension CalendarCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = UIScreen.main.bounds.width - (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0) - (UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0)
        width = (width - 32) / 7
        let height = (UIScreen.main.bounds.width - 32) / 7
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

