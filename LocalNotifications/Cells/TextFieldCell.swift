//
//  TextFieldCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 03/07/24.
//

import UIKit

protocol TextFieldDelegate {
    func onTextFieldChanged(text: String)
}

class TextFieldCell: UITableViewCell {
    let title = {
        let title = UILabel()
        title.text = "Textfield Title"
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        return title
    }()
    
    let textField = {
        let textField = UITextField()
        textField.tintColor = .accent
        textField.textAlignment = .right
        return textField
    }()
    
    private var delegate: TextFieldDelegate?
    
    @objc func onTextFieldChanged() {
        guard let text = textField.text else { return }
        delegate?.onTextFieldChanged(text: text)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let horizontalPadding: CGFloat = 16
        
        //Add calendar
        let container = UIStackView(arrangedSubviews: [title, textField])
        container.axis = .horizontal
        container.spacing = horizontalPadding
        contentView.addSubview(container)
        textField.addTarget(self, action: #selector(onTextFieldChanged), for: .valueChanged)

        //Set constraints as per your requirements
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
    
    func setup(title: String, placeholder: String, delegate: TextFieldDelegate) {
        self.title.text = title
        self.textField.placeholder = placeholder
        self.delegate = delegate
    }
}
