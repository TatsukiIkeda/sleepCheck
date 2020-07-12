//
//  CalendarvViewController.swift
//  sleepCheck
//
//  Created by Tatsuki Ikeda on 2020/06/27.
//  Copyright © 2020 tatsuki.ikeda. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift
import GoogleMobileAds
import EMTNeumorphicView

class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var recordButton: EMTNeumorphicButton!
    @IBOutlet weak var sleepingTimeLabel: UILabel!
    @IBOutlet weak var sleepingLabel: UILabel!
    @IBOutlet weak var gettingUpLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    var bannerView: GADBannerView!
    var sleepingTime: String?
    var gettingUpTime: String?
    var gettingUpYear: Int?
    var gettingUpMonth: Int?
    var gettingUpDay: Int?
    var totalHour: Int?
    var totalMintes: Int?
    var toDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-4646130991450896/7572842532"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        // Do any additional setup after loading the view.
    }
    
    //広告・ボタンの位置に関する関数
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
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
        
        //記録ボタンデザイン
        recordButton.neumorphicLayer?.depthType = .convex
        recordButton.neumorphicLayer?.elementDepth = 10
        recordButton.neumorphicLayer?.cornerRadius = 24
        recordButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor as! CGColor
        
        //遷移直後ではなければボタンは非表示
        if totalHour == nil{
            recordButton.isHidden = true
            recordButton.isEnabled = false
        }
    }
    
    //記録がある日にドットを付ける
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let days = tmpDate.component(.day, from: date)
        let realm = try! Realm()
        let result = realm.objects(CalenderRealm.self).filter("day == '\(days)'").last
        
        if result?.day == "\(days)" && result?.month == "\(month)" && result?.year == "\(year)"
        {
            return 1
        }else{
            return 0
        }
    }
    
    //カレンダーに記憶されたデータを読み込む
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        
        toDay = day
        let da = "\(month)月\(day)日"
        dayLabel.text = da
        
        let realm = try! Realm()
        let results =  realm.objects(CalenderRealm.self).filter("day == '\(toDay)'").last
        
        if  results?.day != nil && results?.hour != nil && results?.month == "\(month)" && results?.year == "\(year)"{
            sleepingTimeLabel.text = "\((results?.hour)!)時間\((results?.mintes)!)分"
            gettingUpLabel.text = "\((results?.gettingUp)!)"
            sleepingLabel.text = "\((results?.sleeping)!)"
        }else{
            sleepingTimeLabel.text = "0時間0分"
            gettingUpLabel.text = "00:00"
            sleepingLabel.text = "00:00"
        }
    }
    //記録ボタン押した後、Realmに保存するボタン
    @IBAction func recordButton(_ sender: UIButton) {
        print("データ書き込み開始")
        
        let realm = try! Realm()
        try! realm.write{
            
            let Events = [CalenderRealm(value: ["year": "\(gettingUpYear!)", "month": "\(gettingUpMonth!)", "day": "\(gettingUpDay!)", "hour": "\(totalHour!)", "mintes": "\(totalMintes!)", "sleeping": "\(sleepingTime!)", "gettingUp": "\(gettingUpTime!)"])]
            
            realm.add(Events)//データ書き込み
        }
    }
    
    @IBAction func unwindPrev(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
    }
}
