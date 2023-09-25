//
//  checkViewCtrl.swift
//  atcClient
//
//  Created by 宋齊鎬 on 2017/12/11.
//  Copyright © 2017年 宋齊鎬. All rights reserved.
//

import UIKit

class checkViewCtrl: UIViewController {
    
    let recordButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.setTitle("訪問記録", for: UIControlState.normal)
        view.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.showsTouchWhenHighlighted = true
        view.addTarget(self, action: #selector(checkViewCtrl.onClickButton(_:)), for: .touchUpInside)
        return view
    }()
    
    let touchButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.setTitle("チェック終了", for: UIControlState.normal)
        view.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.showsTouchWhenHighlighted = true
        view.addTarget(self, action: #selector(checkViewCtrl.onClickButton(_:)), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "業務終了チェック"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
        recordButton.frame = CGRect(x: (self.view.frame.size.width-300)/2, y: self.view.frame.size.height-180, width: 300, height: 60)
        self.view.addSubview(recordButton)
        
        touchButton.frame = CGRect(x: (self.view.frame.size.width-300)/2, y: self.view.frame.size.height-100, width: 300, height: 60)
        self.view.addSubview(touchButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onClickButton(_ sender: UIButton) {
        guard
            sender == recordButton,
            let naviCtrl = self.navigationController
        else {
            return
        }

        let destinationVC = VisitRecordViewCtrl()
        naviCtrl.pushViewController(destinationVC, animated: true)
        
//        // touchButtonを押したら、DBにinsert
//        if sender == recordButton{
//            let destinationVC = VisitRecordViewCtrl()
//            self.navigationController?.pushViewController(destinationVC, animated: true)
//        } else{
//            DataBase.insertMessage(timeInfoName: "2023-09-17 11:00:00", messageTextName: "郵便")
//        }
    }
}
