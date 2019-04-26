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
    var frontDesk:[HealthRecord] = []
    
    var archiveHoldPenalty:Int
    var frontDeskLedger:[String:Int] = [:]
    var frontDeskHoldTime: Int = 5
    
    init(penalty:Int, frontDeskHoldTime:Int) {
        self.archiveHoldPenalty = penalty
//        self.frontDeskHoldTime = 5
    }
    
    private func recordAvailable(for patientName:String) -> Bool{
        return frontDesk.contains(where: {$0.patientName == patientName}) && frontDesk.first(where: {$0.patientName == patientName})?.holdTimeLeft == 0
    }
    
    func record(for patientName:String) -> HealthRecord? {
        if recordAvailable(for: patientName) {
            let rtnRecord = frontDesk.first(where: {$0.patientName == patientName})
            frontDeskLedger[patientName] = frontDeskHoldTime
            return rtnRecord
        }
        else if archive.contains(where: {$0.patientName == patientName}){
            //Record is in archive
            guard let index = archive.firstIndex(where: {$0.patientName == patientName})else{
                return nil
            }
            let rtnRecord = archive[index]
            rtnRecord.holdTimeLeft += archiveHoldPenalty
            
            frontDesk.append(rtnRecord)
            frontDeskLedger[patientName] = frontDeskHoldTime
            archive.remove(at: index)
        }
        return nil
    }
    
    func tick(){
        //Decrement hold on all health records
        for record in archive + frontDesk {
            if record.holdTimeLeft > 0{
                record.holdTimeLeft -= 1
            }
        }
        //Update the records on Front Desk
        let keys = Array(frontDeskLedger.keys)
        for key in keys {
            frontDeskLedger[key] = frontDeskLedger[key]! - 1
            if frontDeskLedger[key]! <= 0 {
                guard let index = frontDesk.firstIndex(where: {$0.patientName == key})else {
                    return
                }
                archive.append(frontDesk[index])
                frontDesk.remove(at: index)
                frontDeskLedger.removeValue(forKey: key)
            }
        }
        
    }
    
}
