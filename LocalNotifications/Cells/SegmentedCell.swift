//
//  ButtonCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 02/07/24.
//

import UIKit

protocol SegmentedCellDelegate {
    func onValueChanged(control: UISegmentedControl) -> Void
}

class SegmentedCell: UITableViewCell {
    let segmentedControl: UISegmentedControl = {
        let items = ["Date", "Interval"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    var delegate: SegmentedCellDelegate?
    
    @objc func onValueChanged(_ sender: Any) {
        delegate?.onValueChanged(control: segmentedControl)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Segmented Control
        contentView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(onValueChanged), for: .valueChanged)
        
        // Set constraints
        let horizontalPadding: CGFloat = 16
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalPadding * -1),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
