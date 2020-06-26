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

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        // Do any additional setup after loading the view.
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

        getSleepTimeDefaults()   ///就寝時間を分に変換してデフォルトデータベースに保存キー値は"sleeoMinuteTime"
        
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
        gettingUpTime.text = DateData
        let ud = UserDefaults.standard
        res = ud.object(forKey: "sleepTime") as! String //の時はエラーになる
//        print(res)
        sleepingTime.text = res
        
        
        Lottienimation()
        animationView.play()
        animationView.stop()
       
       
//        gettingUpTimes() //起床時間を分に変換する
       
        totaleTimes()
       

       

       
        
    }


    ///睡眠時間算出
    func totaleTimes(){
        let date = Date()
        let calendar = Calendar.current
        ///起床時間　日時　時間　分に分ける
        let gettingUpDay = calendar.component(.day, from: date)
        let gettingUpHour = calendar.component(.hour, from: date)
        let gettingUpMintes = calendar.component(.minute, from: date)
        ///就寝時間を　日時　時間　分で取得
        
        sleepDay = UserDefaults.standard.integer(forKey: "SleepDay")
        sleepHour = UserDefaults.standard.integer(forKey: "SleepHour")
        sleepMintes = UserDefaults.standard.integer(forKey: "SleepMintes")
        print(gettingUpDay)
        print(gettingUpHour)
        print(gettingUpMintes)
        print(sleepDay)
        print(sleepHour)
        print(sleepMintes)
        
        
        
        
        //同日中に就寝→起床　例：深夜に就寝、等
        if gettingUpDay == sleepDay{
            if gettingUpHour == sleepHour{
                 totalMintes =  gettingUpMintes - sleepMintes
                totalTime.text =  String("0 時間 \(totalMintes) 分")
            }else if sleepMintes > gettingUpMintes{
                totalHour =   gettingUpHour  - sleepHour - 1
                totalMintes = gettingUpMintes + (60 - sleepMintes)
//                totalTime.text = String("\(totalHour) 時間 \(totalMintes) 分")
            }else{
                totalHour =   gettingUpHour - sleepHour
                totalMintes = gettingUpMintes - sleepMintes
//                totalTime.text = String("\(totalHour) 時間 \(totalMintes) 分")
            }
        }
        ///前日に就寝→翌日起床
        if gettingUpDay != sleepDay{
            if gettingUpMintes == sleepMintes{
                totalHour = (24 - sleepHour) + gettingUpHour
//                totalTime.text = String("\(totalHour) 時間 \(totalMintes) 分")
            }else if sleepMintes > gettingUpMintes {
                totalHour = (24 - sleepHour) + gettingUpHour
                totalMintes = gettingUpMintes + (60 - sleepMintes)
            }
        }
        
        totalTime.text = String("\(totalHour) 時間 \(totalMintes) 分")
    
    }
           
        
    
}

