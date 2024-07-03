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
    var buttonTapCallback: () -> ()  = { }
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Button", for: .normal)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        btn.setTitleColor(.tintColor, for: .normal)
        btn.contentHorizontalAlignment = .leading
        return btn
    }()
    
    var delegate: ButtonCellDelegate?
    
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
}
