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
    
    var sleepDay: Int?
    var totalHour: Int?
    var totalMintes: Int?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(sleepDay!)
//
//        print(totalHour!)
//        print(totalMintes!)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)

        dayLabel.text = "\(year)/\(month)/\(day)"
        
        if day == 29 {
            sleepingTimeLabel.text = "\(totalHour!)時間\(totalMintes!)分"
        
        }
    }
    

        
        
        

    
    
    
    


}
