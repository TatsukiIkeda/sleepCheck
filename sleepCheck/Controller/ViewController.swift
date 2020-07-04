//
//  ViewController.swift
//  sleepCheck
//
//  Created by Tatsuki Ikeda on 2020/06/23.
//  Copyright © 2020 tatsuki.ikeda. All rights reserved.
//

import UIKit
import Lottie
import GoogleMobileAds
import EMTNeumorphicView

class ViewController: UIViewController {
    
    
    @IBOutlet weak var sleepingTime: UILabel!
    @IBOutlet weak var gettingUpTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var sleepButton: EMTNeumorphicButton!
    @IBOutlet weak var resetSegueButton: EMTNeumorphicButton!
    @IBOutlet weak var gettingUpTimeButton: EMTNeumorphicButton!
    
    
    var animationView:AnimationView = AnimationView()
    let ainamtion = Animation.named("ok")
    var bannerView: GADBannerView!
    ///現在時間取得（ロンドン時間）
    let day = Date()
    /// インスタンス生成
    var dateFormatter = DateFormatter()
    var dateData = ""
    var res = ""
    var sleepDay = 0
    var sleepHour = 0
    var sleepMintes = 0
    var totalHour = 0
    var totalMintes = 0
    var gettingUpDay = 0
    var gettingUpMonth = 0
    var gettingUpYear = 0
    var onOffSwitch = 0
    var farstOnOff = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        firstBoot()
        
        
        
    }
    //広告の位置に関する関数
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self.resetSegueButton,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
        
        //寝るボタンデザイン
        sleepButton.neumorphicLayer?.depthType = .convex
        sleepButton.neumorphicLayer?.elementDepth = 10
        sleepButton.neumorphicLayer?.cornerRadius = 24
        sleepButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor as! CGColor
        //起きるボタンデザイン
        gettingUpTimeButton.layer.cornerRadius = 20
        gettingUpTimeButton.neumorphicLayer?.depthType = .convex
        gettingUpTimeButton.neumorphicLayer?.elementDepth = 10
        gettingUpTimeButton.neumorphicLayer?.cornerRadius = 24
        gettingUpTimeButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor as! CGColor
        //リセットボタンデザイン
        resetSegueButton.layer.cornerRadius = 20
        resetSegueButton.neumorphicLayer?.depthType = .convex
        resetSegueButton.neumorphicLayer?.elementDepth = 10
        resetSegueButton.neumorphicLayer?.cornerRadius = 24
        resetSegueButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor as! CGColor
    }
    
    //広告関連の関数
    override func viewDidLayoutSubviews(){
        //  広告インスタンス作成
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        //  広告位置設定
        let safeArea = self.view.safeAreaInsets.bottom
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - safeArea - admobView.frame.height)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        //  広告ID設定
        admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"   //　←　本番IDに戻す
        //  広告表示
        admobView.rootViewController = self
        admobView.load(GADRequest())
        self.view.addSubview(admobView)
    }
    
    
    //初回起動エラー回避判定・起きる・寝るボタン有効化判定
    func firstBoot() {
        farstOnOff = UserDefaults.standard.bool(forKey: "onOff")
        
        if farstOnOff == true {
            gettingUpTimeButton.isEnabled = false
            sleepButton.isEnabled = true
        }else{
            gettingUpTimeButton.isEnabled = true
            sleepButton.isEnabled = false
        }
    }
    
    ///現在時間取得関数
    func dateGet(){
        let day = Date()
        ///ロンドン時間を日本時間に変換
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        ///時間だけをdataに指定
        dateData = String(dateFormatter.string(from: day).suffix(5))
        print(dateData)
    }
    
    ///Lottieアニメーション設定
    func Lottienimation() {
        animationView.frame = CGRect(x: 0, y: 30, width: view.frame.size.width, height: (view.frame.size.height) / 3)
        animationView.animation = ainamtion
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .clear
        view.addSubview(animationView)
        animationView.play()
    }
    
    
    ///寝るボタン
    @IBAction func nightLottieStart(_ sender: Any) {
        dateGet()
        Lottienimation()
        sleepingTime.text = dateData
        getSleepTimeDefaults()
        
        
        
        if farstOnOff == true {
            
            farstOnOff = false
            let onOff = UserDefaults.standard
            onOff.set(farstOnOff, forKey: "onOff")
            onOff.synchronize()
        }else{
            
        }
        
        //userDefaultsに就寝時刻を格納
        let ud = UserDefaults.standard
        ud.set(sleepingTime.text, forKey: "sleepTime")
        ud.synchronize()
        
        gettingUpTimeButton.isEnabled = true
        sleepButton.isEnabled = false
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
        totaleTimes()
        
        gettingUpTimeButton.isEnabled = false ///起きるボタン無効化
        onOffSwitch = 1
        (resetSegueButton as AnyObject).setTitle("記録する", for: .normal)
        
        gettingUpTime.text = dateData
        let ud = UserDefaults.standard
        res = ud.object(forKey: "sleepTime") as! String //の時はエラーになる
        sleepingTime.text = res
        
        
        if farstOnOff == false {
            
            farstOnOff = true
            let onOff = UserDefaults.standard
            onOff.set(farstOnOff, forKey: "onOff")
            onOff.synchronize()
        }else{
            
        }
        
        
        
    }
    
    
    ///睡眠時間算出
    func totaleTimes(){
        let date = Date()
        let calendar = Calendar.current
        ///起床時間　日時　時間　分に分ける
        gettingUpYear = calendar.component(.year, from: date)
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
        gettingUpTimeButton.isEnabled = false
        
        
        if onOffSwitch == 1{
            onOffSwitch = 0
            sender.setTitle("リセット", for: .normal)
            ///画面遷移
            performSegue(withIdentifier: "toNextViewController", sender: nil)
           
        }else{
            onOffSwitch = 0
            
            sleepingTime.text = "00:00"
            gettingUpTime.text = "00:00"
            totalTime.text = "00:00"
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNextViewController"{
            let nextVC = segue.destination as? CalendarViewController
            nextVC?.sleepingTime = sleepingTime.text
            nextVC?.gettingUpTime = gettingUpTime.text
            nextVC?.gettingUpYear = gettingUpYear
            nextVC?.gettingUpMonth = gettingUpMonth
            nextVC?.gettingUpDay = gettingUpDay
            nextVC?.totalHour = totalHour
            nextVC?.totalMintes = totalMintes
        }
    }
    
}

