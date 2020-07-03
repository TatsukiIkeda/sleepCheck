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
import EMTNeumorphicView


class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var recordButton: EMTNeumorphicButton!
    
    @IBOutlet weak var sleepingTimeLabel: UILabel!
    
    @IBOutlet weak var sleepingLabel: UILabel!
    
    @IBOutlet weak var gettingUpLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
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
        
        //記録ボタンデザイン
        recordButton.layer.cornerRadius = 20
        recordButton.neumorphicLayer?.depthType = .convex
        recordButton.neumorphicLayer?.elementDepth = 10
        recordButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor?.cgColor as! CGColor
        
        
        
        
        //遷移直後ではなければボタンは非表示
        if totalHour == nil{
            recordButton.isHidden = true
            recordButton.isEnabled = false
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        let select = getDay(date)
        //        dayLabel.text = "\(select)"
        //
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        //        let dy = day
        print(year)
        print(month)
        print(day)
        toDay = day
        
        let da = "\(month)月\(day)日"
        dayLabel.text = da
        let realm = try! Realm()
        var result = realm.objects(CalenderRealm.self)
        print("1")
        //        let results =  realm.objects(CalenderRealm.self).filter("day == '2'AND month == '7'")
        let results =  realm.objects(CalenderRealm.self).filter("day == '\(toDay)'").last
        print("1")
        print(result)
        
        print(results,month)
        if  results?.day != nil && results?.hour != nil {
            
            sleepingTimeLabel.text = "\((results?.hour)!)時間\((results?.mintes)!)分"
            gettingUpLabel.text = "\((results?.gettingUp)!)"
            sleepingLabel.text = "\((results?.sleeping)!)"
        }else{
            sleepingTimeLabel.text = "00:00"
            gettingUpLabel.text = "00:00"
            sleepingLabel.text = "00:00"
        }
        
        
    }
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
