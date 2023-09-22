//
//  visitRecordViewCtrl.swift
//  atcClient
//
//  Created by 高恩智 on 2023/09/21.
//  Copyright © 2023 宋齊鎬. All rights reserved.
//

import UIKit


/// 訪問記録画面
class VisitRecordViewCtrl: UIViewController {
    let visitRecordsTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var visitRecordsList: [VisitInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitRecordsList = DataBase.selectAll()
        
        visitRecordsTable.register(CustomTableViewCell.self, forCellReuseIdentifier: "customCell")
        visitRecordsTable.delegate = self
        visitRecordsTable.dataSource = self
        view.addSubview(visitRecordsTable)
        
        NSLayoutConstraint.activate([
            visitRecordsTable.topAnchor.constraint(equalTo: view.topAnchor),
            visitRecordsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visitRecordsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visitRecordsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        visitRecordsTable.reloadData()
    }
}

@available(iOS 13.0, *)
extension VisitRecordViewCtrl: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // 最初のセクションには、列の名前を表示(1 つの行のみが含まれる）
            return 1
        } else {
            // 2番目のセクションには、実際のデータ行数だけ含まれる
            return visitRecordsList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.5)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)

            let nameLabel = UILabel()
            nameLabel.text = "順番"
            nameLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true

            let purposeLabel = UILabel()
            purposeLabel.text = "訪問理由"
            purposeLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true

            let timeLabel = UILabel()
            timeLabel.text = "訪問時間"

            let stackView = UIStackView(arrangedSubviews: [nameLabel, purposeLabel, timeLabel])
            stackView.axis = .horizontal
            stackView.spacing = 0
            stackView.alignment = .leading
            stackView.alignment = .fill

            cell.contentView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            ])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
            
            let visitInfo = visitRecordsList[indexPath.row]
            
            cell.idLabel.text = "  \(visitInfo.id!)"
            cell.idLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
            cell.messageLabel.text = visitInfo.messageText
            cell.messageLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
            cell.timeLabel.text = visitInfo.timeInfo
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

