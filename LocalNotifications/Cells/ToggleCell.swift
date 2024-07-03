//
//  ToggleCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 03/07/24.
//

import UIKit
protocol ToggleCellDelegate {
    func onToggleChanged(isEnabled: Bool)
}

class ToggleCell: UITableViewCell {
    let title = {
        let title = UILabel()
        title.text = "Toggle Title"
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        return title
    }()
    let toggle = {
        let toggle = UISwitch()
        return toggle
    }()
    
    private var delegate: ToggleCellDelegate?
    
    @objc func onToggleChanged() {
        let isEnabled = toggle.isEnabled
        delegate?.onToggleChanged(isEnabled: isEnabled)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add calendar
        let container = UIStackView(arrangedSubviews: [title, toggle])
        container.axis = .horizontal
        contentView.addSubview(container)
        toggle.addTarget(self, action: #selector(onToggleChanged), for: .valueChanged)

        //Set constraints as per your requirements
        let horizontalPadding: CGFloat = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalPadding * -1),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, delegate: ToggleCellDelegate) {
        self.title.text = title
        self.delegate = delegate
    }
}
