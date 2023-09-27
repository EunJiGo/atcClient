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
    // テーブル名
    static let table = "messages"
    // 訪問時間
    static let timeInfo = "timeInfo"
    // 訪問理由
    static let messageText = "messageText"
    
    /// テーブル生成
    static func createTable() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS \(table) (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                \(timeInfo) TEXT,
                \(messageText) TEXT
            );
        """
        
        let databaseManager = DatabaseManager.shared
        
        guard databaseManager!.execute(query: createTableQuery) else {
            return
        }
    }
    
    /// テーブルにデータを挿入
    static func insertMessage(timeInfoName: String, messageTextName: String) -> Bool {
        let insertQuery = """
            INSERT INTO \(table) (\(timeInfo), \(messageText))
            VALUES (?, ?);
        """
        
        let databaseManager = DatabaseManager.shared
        
        guard let statement = databaseManager!.executeQuery(query: insertQuery) else {
            return false
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        sqlite3_bind_text(statement, 1, (timeInfoName as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (messageTextName as NSString).utf8String, -1, nil)
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            print("Error executing insert query")
            return false
        }
        
        return true
    }
    
    /// テーブルのすべてのデータ検索
    static func selectAll() -> [VisitInfo] {
        
        let selectQuery = "SELECT * FROM \(table) ORDER BY id DESC;;"
        
        let databaseManager = DatabaseManager.shared
        
        guard let resultSet = databaseManager!.executeQuery(query: selectQuery) else {
            return []
        }
        
        var visitInfoArray: [VisitInfo] = []
        
        defer {
            sqlite3_finalize(resultSet)
        }
        
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
        
        return visitInfoArray
    }
}
