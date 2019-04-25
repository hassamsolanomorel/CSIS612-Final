//
//  Patient.swift
//  CSIS612-Final
//
//  Created by Hassam Solano-Morel on 4/23/19.
//  Copyright © 2019 Hassam. All rights reserved.
//

import Foundation

class Patient {
    
    var name:String
    var healthRecord: HealthRecord
    private var neededProcedures:[Procedure] = []
    
    init(name:String, procedures:[Procedure]) {
        self.name = name
        self.healthRecord = HealthRecord(patientName: name)
        self.neededProcedures = procedures
    }
    
    func addProcedure(procedure:Procedure) {
        neededProcedures.append(procedure)
    }
    
    func removeProcedure() -> Procedure?{
        return neededProcedures.popLast()
    }
    
    func hasMoreProcedures() -> Bool {
        return neededProcedures.count > 0
    }
    
}
