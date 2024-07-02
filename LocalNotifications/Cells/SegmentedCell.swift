//
//  ButtonCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 02/07/24.
//

import UIKit

class SegmentedCell: UITableViewCell {
    var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        setupView()
    }
    
    func setupView() {
        let horizontalPadding: CGFloat = 16
        
        let items = ["Date", "Interval"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(onValueChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: horizontalPadding * -1),
            segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding),
            segmentedControl.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    @objc func onValueChanged(_ sender: Any) {
        
    }
}
