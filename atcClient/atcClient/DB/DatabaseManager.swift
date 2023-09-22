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
    
    fileprivate init() {
        // 데이터베이스 파일 경로 설정
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = documentsDirectory.appendingPathComponent("mydb.sqlite3").path

        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }
    
    func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
    }
    
    func execute(query: String) -> Bool {
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            print("Error preparing query: \(query)")
            return false
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error executing query: \(query)")
            sqlite3_finalize(statement)
            return false
        }
        
        sqlite3_finalize(statement)
        return true
    }
    
    func executeQuery(query: String) -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            print("Error preparing query: \(query)")
            return nil
        }

        return statement
    }

}
