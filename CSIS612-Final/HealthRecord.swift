//
//  HealthRecord.swift
//  CSIS612-Final
//
//  Created by Hassam Solano-Morel on 4/23/19.
//  Copyright © 2019 Hassam. All rights reserved.
//

import Foundation

class HealthRecord {
   
    var patientName:String
    var holdTimeLeft: Int = 0
    var available: Bool {
        return holdTimeLeft == 0
    }
    
    init(patientName:String) {
        self.patientName = patientName
    }
}
