//
//  TextViewCell.swift
//  LocalNotifications
//
//  Created by Rodrigo Cavalcanti on 03/07/24.
//

import UIKit
protocol TextViewCellDelegate {
    func textViewDidChange(text: String)
}

class TextViewCell: UITableViewCell, UITextViewDelegate {
    let title = {
        let title = UILabel()
        title.text = "TextView Title"
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.sizeToFit()
        return title
    }()
    
    let textView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .label
        return textView
    }()
    
    private var delegate: TextViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let horizontalPadding: CGFloat = 16
        
        contentView.addSubview(title)
        contentView.addSubview(textView)
        textView.delegate = self
        
        //Set constraints as per your requirements
        title.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalPadding * -1),
            
            textView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: horizontalPadding / 2),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalPadding),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: horizontalPadding * -1),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(text: textView.text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, delegate: TextViewCellDelegate) {
        self.title.text = title
        self.delegate = delegate
    }
}
