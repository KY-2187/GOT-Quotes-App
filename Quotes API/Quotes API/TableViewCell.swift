//
//  TableViewCell.swift
//  Quotes API
//
//  Created by Kyra Hung on 3/5/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    let italicFont = UIFont.italicSystemFont(ofSize: 18)
    let boldFont = UIFont.boldSystemFont(ofSize: 14)
    
    let quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10;
        stack.alignment = .center
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(quoteLabel)
        stackView.addArrangedSubview(characterLabel)
        quoteLabel.font = italicFont
        characterLabel.font = boldFont

        let constraints = [
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ]
        NSLayoutConstraint.activate(constraints)    }
}
