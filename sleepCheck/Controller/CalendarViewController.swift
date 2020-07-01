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


class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var sleepingTimeLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var gettingUpMonth: Int?
    var gettingUpDay: Int?
    var totalHour: Int?
    var totalMintes: Int?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
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
       
       
       let da = "\(year)\(month)\(day)"

        let realm = try! Realm()
        var result = realm.objects(CalenderRealm.self)
        print("1")
        let results =  realm.objects(CalenderRealm.self).filter("day == '2'")
        let resultss =  realm.objects(CalenderRealm.self).last

//        print("result:", result.description)
        print(results)
        print(resultss)
        print("日 \(result[1].day)")
        print(resultss,month)
      
        sleepingTimeLabel.text = "\((resultss?.mintes)!)"
                
            
           
    }
        

        
        
    
    
    
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//
//
//        ///カレンダー の日付を表示
//
//        let tmpDate = Calendar(identifier: .gregorian)
//        let year = tmpDate.component(.year, from: date)
//        let month = tmpDate.component(.month, from: date)
//        let day = tmpDate.component(.day, from: date)
//        //        let dy = day
//        print(year)
//        print(month)
//        print(day)

//        let days =  "\(year)/\(month)/\(day)"
//
//        dayLabel.text = "\(year)/\(month)/\(day)"
//
//        view.addSubview(dayLabel)
//
//        print(dayLabel.text)
//
//        do {
//
//        let realm = try! Realm()
//        var Rm = realm.objects(CalenderRealm.self)
//         print(Rm)
//        Rm = Rm.filter("day =\(day)")
//
//        sleepingTimeLabel.text = String("\(Rm)")
//            print(Rm)
//            print(Rm)
//        }
//
//
//
//
//    }
//
    
//    func getDay(_ date: Date) -> (String) {
////        let tmpDate = Calendar(identifier: .gregorian)
////        let year = tmpDate.component(.year, from: date)
////        let month = tmpDate.component(.month, from: date)
////        let day = tmpDate.component(.day, from: date)
////        //        let dy = day
////        print(year)
////        print(month)
////        print(day)
////
////
////        return "\(year),\(month),\(day)"
//    }
    
    
    
    
    
    @IBAction func recordButton(_ sender: UIButton) {
        if gettingUpDay != nil{
        print("データ書き込み開始")
        
        let realm = try! Realm()
        try! realm.write{
                
      
            let Events = [CalenderRealm(value: ["month": "\(gettingUpMonth!)", "day": "\(gettingUpDay!)", "hour": "\(totalHour!)", "mintes": "\(totalMintes!)"])]
            
                    realm.add(Events)//データ書き込み
        

        
        print(Realm.Configuration.defaultConfiguration.fileURL)//パス表示
        
        
        print("データ書き込み中")
        }
        print("データ書き込み完了")
          
            
        
        
 
       }
    }
    
    
    @IBAction func unwindPrev(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
        
        
    }
    
    
}
