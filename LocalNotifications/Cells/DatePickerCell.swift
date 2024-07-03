//
//  DatePickerCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 03/07/24.
//

import UIKit

protocol DatePickerDelegate {
    func onDateChanged(date: Date)
    func customizeDatePicker(to type: DatePickerType)
    var datePicker: UIDatePicker? { get set }
}

class DatePickerCell: UITableViewCell {
    let datePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = .now
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
    private var delegate: DatePickerDelegate?
    
    @objc func onDateChanged() {
        let date = datePicker.date
        delegate?.onDateChanged(date: date)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add calendar
        contentView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)

        //Set constraints as per your requirements
        let horizontalPadding: CGFloat = 16
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalPadding * -1),
            datePicker.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(delegate: DatePickerDelegate, datePicker: inout UIDatePicker?) {
        self.delegate = delegate
        datePicker = self.datePicker
    }
}

enum DatePickerType: Int, CaseIterable {
    case dateAndTime, time, countDownTimer
    
    var title: String {
        switch self {
        case .dateAndTime:
            return "Date"
        case .time:
            return "Time"
        case .countDownTimer:
            return "Interval"
        }
    }
}
