//
//  startViewCtrl.swift
//  actfrom
//
//  Created by 宋齊鎬 on 2017/12/09.
//  Copyright © 2017年 宋齊鎬. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class startViewCtrl: UIViewController, AVAudioPlayerDelegate, waitMessageDelegate, SFSpeechRecognitionTaskDelegate {

    let backView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "scrback.png")
        view.contentMode = UIViewContentMode.scaleAspectFit
        return view
    }()
    
    let timeTitle: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.darkGray
        view.font = UIFont.systemFont(ofSize: 48)
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    let touchButton: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.showsTouchWhenHighlighted = true
        view.addTarget(self, action: #selector(startViewCtrl.onClickButton(_:)), for: .touchUpInside)
        return view
    }()
    
    let touchButton2: UIButton = {
        let view = UIButton()
        view.tag = 1
        view.showsTouchWhenHighlighted = true
        view.addTarget(self, action: #selector(startViewCtrl.onClickButton(_:)), for: .touchUpInside)
        return view
    }()
    
    var audioPlayer : AVAudioPlayer!
    
    var myCurrDate:Date!
    var myTimer: Timer!
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    var recognitionTask: SFSpeechRecognitionTask?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        let soundFilePath : String = Bundle.main.path(forResource: "click", ofType: "mp3")!
        let fileURL : URL = URL(fileURLWithPath: soundFilePath)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = self
        }
        catch{
        }

        backView.frame = CGRect(x: 0, y: 0, width: 1024, height: 768)
        self.view.addSubview(backView)
        
        timeTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
        self.view.addSubview(timeTitle)
        
        touchButton.frame = CGRect(x: 150, y: 200, width: 723, height: 150)
        self.view.addSubview(touchButton)
        
        touchButton2.frame = CGRect(x: 150, y: 470, width: 723, height: 150)
        self.view.addSubview(touchButton2)
        
        p2pConnectivity.manager.start(serviceType: "MIKE-SIMPLE-P2P",
                                      displayName: UIDevice.current.name,
                                      stateChangeHandler: { state in
                                        print("state = \(state)")
                                    }, recieveHandler: { data in
                                        print("data = \(data)")

                                        DispatchQueue.main.async { // Correct
                                            self.close_waitMsg()
                                        }
                                    }
        )
        
        resetTimeDate()
        startTimer()
    }
    
    func startRecording() throws {
        
        if let recognitionTask = recognitionTask {
            // 既存タスクがあればキャンセルしてリセット
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard recognitionRequest != nil else { fatalError("リクエスト生成エラー") }
        
        recognitionRequest?.shouldReportPartialResults = true
        
        let inputNode:AVAudioInputNode = audioEngine.inputNode
        //guard inputNode else { fatalError("InputNodeエラー") }
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
            var isFinal = false
            
            if let result = result {
                //self.textView.text = result.bestTranscription.formattedString
                print("result = \(result.bestTranscription.formattedString)")
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
//                self.recordButton.isEnabled = true
//                self.recordButton.setTitle("Start Recording", for: [])
//                self.recordButton.backgroundColor = UIColor.blue
                
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()   // オーディオエンジン準備
        try audioEngine.start() // オーディオエンジン開始
        
        print("認識中…そのまま話し続けてください")
        //textView.text = "(認識中…そのまま話し続けてください)”
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        speechRecognizer.delegate = self as? SFSpeechRecognizerDelegate    // デリゲート先になる
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:   // 許可OK
                    print("許可OK")
                case .denied:       // 拒否
                    print("拒否")
                case .restricted:   // 限定
                    print("限定")
                case .notDetermined:// 不明
                    print("不明")
                }
            }
        }
    }
    
    func recordButtonTapped() {
        
        if audioEngine.isRunning {
            // 音声エンジン動作中なら停止
            audioEngine.stop()
            recognitionRequest?.endAudio()
//            recordButton.isEnabled = false
//            recordButton.setTitle("Stopping", for: .disabled)
//            recordButton.backgroundColor = UIColor.lightGray
            return
        }
        // 録音を開始する
        try! startRecording()
//        recordButton.setTitle("認識を完了する", for: [])
//        recordButton.backgroundColor = UIColor.red
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            // 利用可能になったら、録音ボタンを有効にする
//            recordButton.isEnabled = true
//            recordButton.setTitle("Start Recording", for: [])
//            recordButton.backgroundColor = UIColor.blue
        } else {
            // 利用できないなら、録音ボタンは無効にする
//            recordButton.isEnabled = false
//            recordButton.setTitle("現在、使用不可", for: .disabled)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myTimer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(resetTimeDate), userInfo: nil, repeats: true)
    }
    
    @objc func resetTimeDate() {
        
        myCurrDate = Date()
        
        timeTitle.text = topDateFormat(date: myCurrDate! as NSDate)
    }
    
    @objc func onClickButton(_ sender: UIButton) {
        
//        try! startRecording()
        audioPlayer.play()
        
        var buttonType = ""
        let buttonPressTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let buttonClickTime = dateFormatter.string(from: buttonPressTime)

        if sender == touchButton {
            buttonType = "visit"
            
        } else {
            buttonType = "post"
        }
        
        p2pConnectivity.manager.send(message: "\(buttonType, buttonClickTime)")

        let watView = waitMessageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        watView.backgroundColor = UIColor.white
        watView.delegate = self
        watView.tag = 1000
        watView.buttonType = buttonType
        self.view.addSubview(watView)
    }
    
    func close_waitMsg() {
        self.view.viewWithTag(1000)?.removeFromSuperview()
    }
    
    func close_waitView(myView:UIView) {
        myView.removeFromSuperview()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error")
    }
}

extension startViewCtrl {
    
    func topDateFormat(date: NSDate) -> String {
        
        var yobi = getYobiTitle(date: date)
        yobi = gngSubstring(str: yobi, length: 1)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日（\(yobi)）H:mm"
        
        return formatter.string(from: date as Date)
    }
    
    func getYobiTitle(date:NSDate) -> String {
        
        let cal: NSCalendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        let comp: NSDateComponents = cal.components(
            [NSCalendar.Unit.weekday],
            from: date as Date
            ) as NSDateComponents
        
        let weekday: Int = comp.weekday - 1
        
        let formatter: DateFormatter = DateFormatter()
        
        formatter.locale = NSLocale(localeIdentifier: "ja") as Locale!
        
        return formatter.weekdaySymbols[weekday]
    }
    
    func gngSubstring(str:String, length:NSInteger) -> String {
        
        return String(str.prefix(length))
    }
}
