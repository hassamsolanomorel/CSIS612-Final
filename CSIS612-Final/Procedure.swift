//
//  Procedure.swift
//  CSIS612-Final
//
//  Created by Hassam Solano-Morel on 4/23/19.
//  Copyright © 2019 Hassam. All rights reserved.
//

import Foundation

class Procedure {
    
    var title:String
    var recordHoldTime:Int
    var currentPatient:Patient?
    
    init(title:String, recordHoldTime:Int) {
        self.title = title
        self.recordHoldTime = recordHoldTime
    }
}
