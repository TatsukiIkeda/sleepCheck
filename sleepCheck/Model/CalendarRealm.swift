//
//  CalendarRealm.swift
//  sleepCheck
//
//  Created by Tatsuki Ikeda on 2020/06/29.
//  Copyright © 2020 tatsuki.ikeda. All rights reserved.
//

import Foundation
import RealmSwift

class CalenderRealm: Object{
    @objc dynamic var month : String = ""
    @objc dynamic var day : String = ""
   @objc dynamic var hour : String  = ""
   @objc dynamic var mintes : String  = ""

    
}
