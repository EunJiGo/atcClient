//
//  waitMessageView.swift
//  actfrom
//
//  Created by 宋齊鎬 on 2017/12/09.
//  Copyright © 2017年 宋齊鎬. All rights reserved.
//

import UIKit
import AVFoundation

protocol waitMessageDelegate: class {
    
    func close_waitView(myView:UIView)
}

class waitMessageView: UIView, AVAudioPlayerDelegate {
    
    weak var delegate: waitMessageDelegate? = nil
    
    let waitMsg: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.darkGray
        view.text = "呼び出しています\r少々お待ちください。"
        view.font = UIFont.systemFont(ofSize: 60)
        view.textAlignment = NSTextAlignment.center
        view.numberOfLines = 0
        return view
    }()
    
    let status: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.init(red: 244, green: 0, blue: 228, alpha: 0.3)
        view.font = UIFont.systemFont(ofSize: 36)
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    let womanImg: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "woman.jpg")
        view.contentMode = UIViewContentMode.scaleAspectFit
        return view
    }()
    
    var audioPlayer : AVAudioPlayer!
    
    var anyTimer: Timer!
    var anyNum = 0
    let anyMsg:[Any] = ["","▶︎","▶︎▶︎","▶︎▶︎▶︎","▶︎▶︎▶︎▶︎","▶︎▶︎▶︎▶︎▶︎"]
    
    override func draw(_ rect: CGRect) {
        
        let soundFilePath : String = Bundle.main.path(forResource: "irasyai", ofType: "mp3")!
        let fileURL : URL = URL(fileURLWithPath: soundFilePath)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = self
        }
        catch{
        }

        womanImg.frame = CGRect(x: 70, y: 110, width: 482, height: 500)
        self.addSubview(womanImg)
        
        waitMsg.frame = CGRect(x:360 , y: 100, width: self.frame.width-420, height: 200)
        self.addSubview(waitMsg)
        
        status.frame = CGRect(x: 580, y: 400, width: 260, height: 100)
        self.addSubview(status)
        
        self.perform(#selector(playSound), with: nil, afterDelay: 0.3)
        
        self.perform(#selector(closeProc), with: nil, afterDelay: 5.0)
    }
    
    @objc func playSound() {
        audioPlayer.play()
        anyTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(chkAnimation), userInfo: nil, repeats: true)
    }
    
    @objc func chkAnimation() {
        
        if anyNum < 5 {
            anyNum += 1
        }
        else {
            anyNum = 0
        }
        status.text = anyMsg[anyNum] as? String
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error")
    }
    
    @objc func closeProc() {
        self.delegate?.close_waitView(myView: self)
    }
}
