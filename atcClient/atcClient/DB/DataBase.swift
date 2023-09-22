//
//  dataBaseManager.swift
//  atcClient
//
//  Created by 高恩智 on 2023/09/19.
//  Copyright © 2023 宋齊鎬. All rights reserved.
//

import Foundation
import SQLite3

/// データベース管理\
class DataBase {
    static let table = "messages"
    static let timeInfo = "timeInfo"
    static let messageText = "messageText"
    
    static func createTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS \(table) (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                \(timeInfo) TEXT,
                \(messageText) TEXT
            );
        """
        
        let databaseManager = DatabaseManager.shared
        
        if databaseManager.execute(query: createTableQuery) {
            print("\(table) table created.")
        } else {
            print("Table creation failed.")
        }
    }
    
    static func insertMessage(timeInfo: String, messageText: String) -> Bool {
        let insertQuery = """
            INSERT INTO \(table) (\(timeInfo), \(messageText))
            VALUES (?, ?);
        """
        
        let databaseManager = DatabaseManager.shared
        
        if databaseManager.execute(query: insertQuery) {
            print("Data inserted into \(table).")
            return true
        } else {
            print("Failed to insert data into \(table).")
            return false
        }
    }

    static func selectAll() -> [VisitInfo] {
        var visitInfoArray: [VisitInfo] = []

        let selectQuery = "SELECT * FROM \(table);"
        
        let databaseManager = DatabaseManager.shared
        if let resultSet = databaseManager.executeQuery(query: selectQuery) {
            while sqlite3_step(resultSet) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(resultSet, 0))
                let timeInfo = String(cString: sqlite3_column_text(resultSet, 1))
                let messageText = String(cString: sqlite3_column_text(resultSet, 2))
                
                let visitInfo = VisitInfo()
                visitInfo.id = id
                visitInfo.timeInfo = timeInfo
                visitInfo.messageText = messageText
                
                visitInfoArray.append(visitInfo)
            }
            sqlite3_finalize(resultSet)
        }

        return visitInfoArray
    }
}
