//
//  ButtonCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 02/07/24.
//

import UIKit

protocol ButtonCellDelegate {
    func onDidTapButton(cell: ButtonCell) -> Void
}

class ButtonCell: UITableViewCell {
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Button", for: .normal)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        btn.contentHorizontalAlignment = .leading
        return btn
    }()
    
    private var delegate: ButtonCellDelegate?
    
    @objc func onDidTapButton(cell: ButtonCell) -> Void {
        delegate?.onDidTapButton(cell: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add button
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(onDidTapButton), for: .touchUpInside)
        
        //Set constraints as per your requirements
        let horizontalPadding: CGFloat = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalPadding * -1),
            button.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customize(title: String, color: UIColor, delegate: ButtonCellDelegate) {
        self.delegate = delegate
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        if color == .white {
            button.contentHorizontalAlignment = .center
            contentView.backgroundColor = .tintColor
        }
    }
}
