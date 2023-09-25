//
//  startViewCtrl.swift
//  actClient
//
//  Created by 宋齊鎬 on 2017/12/09.
//  Copyright © 2017年 宋齊鎬. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class startViewCtrl: UIViewController, AVAudioPlayerDelegate {
    
    let timeTitle: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.text = "受付中・・・"
        view.font = UIFont.systemFont(ofSize: 80)
        view.textAlignment = NSTextAlignment.center
        view.numberOfLines = 0
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let setImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "setup.png")
        view.contentMode = UIViewContentMode.scaleAspectFit
        return view
    }()
    
    let touchButton: UIButton = {
        let view = UIButton()
        view.showsTouchWhenHighlighted = true
        view.addTarget(self, action: #selector(startViewCtrl.onClickButton(_:)), for: .touchUpInside)
        return view
    }()
    
    var audioPlayer : AVAudioPlayer!
    var isWait = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataBase.createTable()
        
        self.view.backgroundColor = UIColor.clear
        
        let myTap = UITapGestureRecognizer(target: self, action: #selector(startViewCtrl.tapGesture(sender:)))
        self.view.addGestureRecognizer(myTap)
        
        timeTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(timeTitle)
        
        setImg.frame = CGRect(x: self.view.frame.size.width-120, y: self.view.frame.height-120, width: 100, height: 100)
        self.view.addSubview(setImg)
        
        touchButton.frame = setImg.frame
        self.view.addSubview(touchButton)
        
        p2pConnectivity.manager.start(serviceType: "MIKE-SIMPLE-P2P",
                                      displayName: UIDevice.current.name,
                                      stateChangeHandler: { state in
            print("state = \(state)")
        }, recieveHandler: { data in
            print("data = \(data)")
            
            DispatchQueue.main.async { // Correct
                self.dispCustomer(data)
            }
        }
        )
    }
    
    func dispCustomer(_ message: String) {
        isWait = false
        var messageText = ""
        var soundFileName = ""
        
        let buttonInfo = message.components(separatedBy: ",")
        
        guard buttonInfo.count >= 2 else {
            return
        }
        
        let buttonType = buttonInfo[0]
        let buttonClickTime = buttonInfo[1]
        
        switch buttonType {
        case "post":
            messageText = "配達又は郵便のお届けです。\r迎えて下さい"
            soundFileName = "postMusic"
            
        default:
            messageText = "お客様が\rいらっしゃいました。\r迎えて下さい"
            soundFileName = "irasyai"
        }

        guard DataBase.insertMessage(timeInfoName: buttonClickTime, messageTextName: buttonType) else {
            return
        }
        
        timeTitle.text = messageText
        
        if let soundFilePath = Bundle.main.path(forResource: soundFileName, ofType: "mp3") {
            let fileURL = URL(fileURLWithPath: soundFilePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch {
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error")
    }
    
    @objc func tapGesture(sender: UITapGestureRecognizer){
        
        if isWait == false {
            timeTitle.text =  "受付中・・・"
            isWait = true
            p2pConnectivity.manager.send(message: "送信")
        }
    }
    
    @objc func onClickButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(checkViewCtrl(), animated: true)
    }
}
