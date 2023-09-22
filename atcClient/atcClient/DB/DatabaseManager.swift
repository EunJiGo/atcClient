//
//  dataBaseManager.swift
//  atcClient
//
//  Created by 高恩智 on 2023/09/19.
//  Copyright © 2023 宋齊鎬. All rights reserved.
//

import Foundation
import SQLite3

/// データベースへの接続とクエリを実行
class DatabaseManager {
    static let shared = DatabaseManager()
    var db: OpaquePointer? = nil
    
    fileprivate init() {
        /// データベースファイル経路の設定
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = documentsDirectory.appendingPathComponent("mydb.sqlite3").path
        
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            return
        }
        print(documentsDirectory)
    }
    
    /// データベース接続を閉じる
    func closeDatabase() {
        guard sqlite3_close(db) == SQLITE_OK else {
            return
        }
    }
    
    /// データベース操作
    func execute(query: String) -> Bool {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return false
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            sqlite3_finalize(statement)
            return false
        }
        
        sqlite3_finalize(statement)
        return true
    }
    
    /// データベースからデータを検索し、結果を返
    func executeQuery(query: String) -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            return nil
        }
        return statement
    }
}
