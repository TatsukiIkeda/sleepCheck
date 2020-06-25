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
    let dateFormatter = DateFormatter()
    var DateData: String = ""
    var res = ""
    var sleep = 0
    var gettingUp = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    ///現在時間変換関数
    func dateGet(){
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

        getSleepTime()   ///就寝時間を分に変換してデフォルトデータベースに保存キー値は"sleeoMinuteTime"
        
        //userDefaultsに就寝時刻を格納
      let ud = UserDefaults.standard
      ud.set(sleepingTime.text, forKey: "sleepTime")
      ud.synchronize()
    }
    ///就寝時間を分に変換して保存
    func getSleepTime(){
           let date = Date()
           let calendar = Calendar.current
           
           var hour = calendar.component(.hour, from: date)
           hour = hour * 60
           let mintes = calendar.component(.minute, from: date)
           let totalDayTime = hour + mintes
           
           
           let userDefaults = UserDefaults.standard
           userDefaults.set(totalDayTime, forKey: "sleeoMinuteTime")
           userDefaults.synchronize()
           print(totalDayTime)
       }
       
    

    
    ///起きるボタンアニメーション
    @IBAction func nightLottieStop(_ sender: Any) {
        let ud = UserDefaults.standard
        res = ud.object(forKey: "sleepTime") as! String //の時はエラーになる
        print(res)
        sleepingTime.text = res
        
        dateGet()
        Lottienimation()
        animationView.play()
        animationView.stop()
        gettingUpTime.text = DateData
       
        gettingUpTimes() //起床時間を分に変換する
        sleep = UserDefaults.standard.integer(forKey: "sleeoMinuteTime") //の時はエラーになる
        print(sleep)
       print(gettingUp)
        totalTime.text = "\(sleep + gettingUp)"
       
        
    }

    func gettingUpTimes() {
        let date = Date()
        let calendar = Calendar.current
        
        var hour = calendar.component(.hour, from: date)
        hour = hour * 60
        let mintes = calendar.component(.minute, from: date)
         gettingUp = hour + mintes
        
        
        
    }
    
    func totaleTime(){
        
        
    }
    
    
    
    
    
}

