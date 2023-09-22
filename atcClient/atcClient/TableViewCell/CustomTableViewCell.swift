//
//  CustomTableViewCell.swift
//  atcClient
//
//  Created by 高恩智 on 2023/09/21.
//  Copyright © 2023 宋齊鎬. All rights reserved.
//

import UIKit

/// テーブルビューセルデザイン
class CustomTableViewCell: UITableViewCell {
    let idLabel = UILabel()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        idLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) は実装されていません")
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [idLabel, messageLabel, timeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.alignment = .fill
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

}
