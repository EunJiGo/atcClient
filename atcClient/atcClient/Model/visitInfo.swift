//
//  visitInfo.swift
//  atcClient
//
//  Created by 高恩智 on 2023/09/21.
//  Copyright © 2023 宋齊鎬. All rights reserved.
//

import Foundation

/// 訪問記録情報
class VisitInfo {
    
    /// ボタンの呼び出し順
    var id: Int?
    
    /// 訪問時間
    var timeInfo: String = ""
    
    /// 訪問理由
    var messageText: String = ""
}
