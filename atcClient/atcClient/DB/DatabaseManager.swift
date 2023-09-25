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
    private var db: OpaquePointer? = nil
    
    private init?() {
        /// データベースファイル経路の設定
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = documentsDirectory.appendingPathComponent("mydb.sqlite3").path
        
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            return nil
        }
    }

    /// データベース接続を閉じる
    func closeDatabase() {
        guard sqlite3_close(db) == SQLITE_OK else {
            print("Failed to close the database")
            return
        }
    }
    
    /// データベース操作
    func execute(query: String) -> Bool {
        var statement: OpaquePointer? = nil

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("SQLite error: \(errorMessage)")
            return false
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            return false
        }

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
