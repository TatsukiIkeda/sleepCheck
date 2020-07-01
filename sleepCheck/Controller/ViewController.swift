//
//  ViewController.swift
//  sleepCheck
//
//  Created by Tatsuki Ikeda on 2020/06/23.
//  Copyright © 2020 tatsuki.ikeda. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    
    @IBOutlet weak var sleepingTime: UILabel!
    @IBOutlet weak var gettingUpTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var resetSegueButton: UIButton!
    @IBOutlet weak var gettingUpTimeButton: UIButton!
    
    
    var animationView:AnimationView = AnimationView()
    let ainamtion = Animation.named("night")
    
    ///現在時間取得（ロンドン時間）
    let day = Date()
    /// インスタンス生成
    var dateFormatter = DateFormatter()
    var DateData = ""
    var res = ""
    var sleepDay = 0
    var sleepHour = 0
    var sleepMintes = 0
    var totalHour = 0
    var totalMintes = 0
    var onOffCCount = 0
    var gettingUpDay = 0
    var gettingUpMonth = 0
    var farstOnOff = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        firstAdd()
        
        
        // Do any additional setup after loading the view.
    }
    //初回起動エラー回避判定・起きる・寝るボタン有効化判定
    func firstAdd() {
        farstOnOff = UserDefaults.standard.bool(forKey: "onOff")
        
        if farstOnOff == true {
            gettingUpTimeButton.isEnabled = false
        }else{
            onOffCCount = UserDefaults.standard.integer(forKey: "onOff")
            sleepButton.isEnabled = false
            gettingUpTimeButton.isEnabled = true
        }
        
        
        
        
    }
    
    
    ///現在時間変換関数
    func dateGet(){
        let day = Date()
        ///ロンドン時間を日本時間に変換
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        ///時間だけをdataに指定
        DateData = String(dateFormatter.string(from: day).suffix(5))
        print(DateData)
    }
    ///Lottieアニメーション設定
    func Lottienimation() {
        animationView.frame = CGRect(x: 0, y: 10, width: view.frame.size.width, height: (view.frame.size.height) / 3)
        animationView.animation = ainamtion
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .clear
        view.addSubview(animationView)
    }
    
    
    ///寝るボタンアニメーション
    @IBAction func nightLottieStart(_ sender: Any) {
        dateGet()
        Lottienimation()
        animationView.play()
        sleepingTime.text = DateData
        getSleepTimeDefaults()
        farstOnOff = false
        
        if onOffCCount == 0 {
            sleepButton.isEnabled = false ///寝るボタン無効化
            gettingUpTimeButton.isEnabled = true  ///起きるボタン有効化
            
        }else{
            onOffCCount = 0
            
            
        }
        farstOnOff = false
        let onOff = UserDefaults.standard
        onOff.set(farstOnOff, forKey: "onOff")
        onOff.synchronize()
        
        //userDefaultsに就寝時刻を格納
        let ud = UserDefaults.standard
        ud.set(sleepingTime.text, forKey: "sleepTime")
        ud.synchronize()
    }
    
    
    
    ///就寝時間を分に変換して保存
    func getSleepTimeDefaults(){
        let date = Date()
        let calendar = Calendar.current
        ///日時　時間　分に分ける
        let sleepDayDefaults = calendar.component(.day, from: date)
        let sleepHourDefaults = calendar.component(.hour, from: date)
        let sleepMintesDefaults = calendar.component(.minute, from: date)
        ///デリゲートに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(sleepDayDefaults, forKey: "SleepDay")
        userDefaults.set(sleepHourDefaults, forKey: "SleepHour")
        userDefaults.set(sleepMintesDefaults, forKey: "SleepMintes")
        userDefaults.synchronize()
        
    }
    
    
    
    ///起きるボタンアニメーション
    @IBAction func nightLottieStop(_ sender: Any) {
        dateGet()
        Lottienimation()
        animationView.play()
        animationView.stop()
        totaleTimes()
        
        
        gettingUpTimeButton.isEnabled = false ///起きるボタン無効化
        
        
        gettingUpTime.text = DateData
        let ud = UserDefaults.standard
        res = ud.object(forKey: "sleepTime") as! String //の時はエラーになる
        sleepingTime.text = res
    }
    
    
    ///睡眠時間算出
    func totaleTimes(){
        let date = Date()
        let calendar = Calendar.current
        ///起床時間　日時　時間　分に分ける
        gettingUpMonth = calendar.component(.month, from: date)
        gettingUpDay = calendar.component(.day, from: date)
        let gettingUpHour = calendar.component(.hour, from: date)
        let gettingUpMintes = calendar.component(.minute, from: date)
        ///就寝時間を　日時　時間　分で取得
        
        sleepDay = UserDefaults.standard.integer(forKey: "SleepDay")
        sleepHour = UserDefaults.standard.integer(forKey: "SleepHour")
        sleepMintes = UserDefaults.standard.integer(forKey: "SleepMintes")
        
        
        //        同日中に就寝→起床　例：深夜に就寝、等
        if gettingUpDay == sleepDay{
            if gettingUpHour == sleepHour {
                totalMintes =  gettingUpMintes - sleepMintes
                totalHour =   0
            }else if sleepMintes > gettingUpMintes {
                totalHour =   gettingUpHour  - sleepHour - 1
                totalMintes = gettingUpMintes + (60 - sleepMintes)
            }else{
                totalHour =   gettingUpHour - sleepHour
                totalMintes = gettingUpMintes - sleepMintes
            }
        }
        ///前日に就寝→翌日起床
        if gettingUpDay != sleepDay {
            if gettingUpMintes == sleepMintes {
                totalHour = (24 - sleepHour) + gettingUpHour
                totalMintes = 0
            }else if sleepMintes > gettingUpMintes {
                totalHour = (23 - sleepHour) + gettingUpHour
                totalMintes = gettingUpMintes + (60 - sleepMintes)
            }else{
                totalHour = (23 - sleepHour) + gettingUpHour
                totalMintes = gettingUpMintes + sleepMintes
                if totalMintes > 60 {
                    totalMintes = gettingUpMintes  - sleepMintes
                    totalHour = totalHour + 1
                }
            }
        }
        totalTime.text = String("\(totalHour) 時間 \(totalMintes) 分")
    }
    
    ///スタート、リセット、記憶ボタン
    @IBAction func resetSegue(_ sender: UIButton) {
        
        sleepButton.isEnabled = true
        
        print(totalHour)
        print(totalMintes)
        if onOffCCount == 0{
            
            
            performSegue(withIdentifier: "toNextViewController", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController"{
            let nextVC = segue.destination as? CalendarViewController
            nextVC?.gettingUpMonth = gettingUpMonth
            nextVC?.gettingUpDay = gettingUpDay
            nextVC?.totalHour = totalHour
            nextVC?.totalMintes = totalMintes
            
        }
        
        
        
    }
    
}

