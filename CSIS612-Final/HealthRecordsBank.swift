//
//  HealthRecordsBank.swift
//  CSIS612-Final
//
//  Created by Hassam Solano-Morel on 4/23/19.
//  Copyright © 2019 Hassam. All rights reserved.
//

import Foundation

class HealthRecordsBank{
    
    var archive:[HealthRecord] = []
    private var frontDesk:[HealthRecord] = []
    
    private var archiveHoldPenalty:Int
    private var frontDeskLedger:[String:Int] = [:]
    private let frontDeskHoldTime: Int = 5
    
    init(penalty:Int) {
        self.archiveHoldPenalty = penalty
    }
    
    private func recordAvailable(for patientName:String) -> Bool{
        for record in archive {
            if record.patientName == patientName{
                return  record.available
            }
        }
        return false
    }
    
    func record(for patientName:String) -> HealthRecord? {
        if recordAvailable(for: patientName){
            //Check the front desk
            for record in frontDesk {
                if record.patientName == patientName {
                    frontDeskLedger[patientName] = frontDeskHoldTime
                    return record
                }
            }
            
            //Record is in archive
            let rtnRecord = archive.first(where: {$0.patientName == patientName})
            rtnRecord?.holdTimeLeft += archiveHoldPenalty
            
            frontDesk.append(rtnRecord!)
            frontDeskLedger[patientName] = frontDeskHoldTime
            return rtnRecord
        }
        return nil
    }
    
    func tick(){
        //Decrement hold on all health records
        for record in archive {
            if record.holdTimeLeft > 0{
                record.holdTimeLeft -= 1
            }
        }
        
        let keys = Array(frontDeskLedger.keys)
        for key in keys {
            frontDeskLedger[key] = frontDeskLedger[key]! - 1
            if frontDeskLedger[key]! <= 0 {
                frontDeskLedger.removeValue(forKey: key)
            }
        }
        
    }
    
}
