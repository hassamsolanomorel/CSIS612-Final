//
//  ViewController.swift
//  CSIS612-Final
//
//  Created by Hassam Solano-Morel on 4/23/19.
//  Copyright © 2019 Hassam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Inputs
    @IBOutlet weak var numPatientsTextBox: UITextField!
    @IBOutlet weak var maxRecordHoldTextBox: UITextField!
    //Views
    @IBOutlet weak var frontDeskTableView: UITableView!
    @IBOutlet weak var archiveTableView: UITableView!
    
    @IBOutlet weak var frontDeskTime: UILabel!
    @IBOutlet weak var archiveTime: UILabel!
    
    //Labels
    @IBOutlet weak var tickLabel: UILabel!
        //Column1
    @IBOutlet weak var L11: UILabel!
    @IBOutlet weak var L21: UILabel!
    @IBOutlet weak var L31: UILabel!
    @IBOutlet weak var L41: UILabel!
    @IBOutlet weak var L51: UILabel!
        //Column2
    @IBOutlet weak var L12: UILabel!
    @IBOutlet weak var L22: UILabel!
    @IBOutlet weak var L32: UILabel!
    @IBOutlet weak var L42: UILabel!
    @IBOutlet weak var L52: UILabel!
    //Column3
    @IBOutlet weak var L13: UILabel!
    @IBOutlet weak var L23: UILabel!
    @IBOutlet weak var L33: UILabel!
    @IBOutlet weak var L43: UILabel!
    @IBOutlet weak var L53: UILabel!
    //Column4
    @IBOutlet weak var L14: UILabel!
    @IBOutlet weak var L24: UILabel!
    @IBOutlet weak var L34: UILabel!
    @IBOutlet weak var L44: UILabel!
    @IBOutlet weak var L54: UILabel!
    //Column5
    @IBOutlet weak var L15: UILabel!
    @IBOutlet weak var L25: UILabel!
    @IBOutlet weak var L35: UILabel!
    @IBOutlet weak var L45: UILabel!
    @IBOutlet weak var L55: UILabel!
    //Next Patients
    @IBOutlet weak var patient1: UILabel!
    @IBOutlet weak var patient2: UILabel!
    @IBOutlet weak var patient3: UILabel!
    @IBOutlet weak var patient4: UILabel!
    @IBOutlet weak var patient5: UILabel!
    
    var col1:[UILabel] = []
    var col2:[UILabel] = []
    var col3:[UILabel] = []
    var col4:[UILabel] = []
    var col5:[UILabel] = []
    //Procedure Buttons
    @IBOutlet weak var P1: UIButton!
    @IBOutlet weak var P2: UIButton!
    @IBOutlet weak var P3: UIButton!
    @IBOutlet weak var P4: UIButton!
    @IBOutlet weak var P5: UIButton!
    
    @IBOutlet weak var P1Time: UILabel!
    @IBOutlet weak var P2Time: UILabel!
    @IBOutlet weak var P3Time: UILabel!
    @IBOutlet weak var P4Time: UILabel!
    @IBOutlet weak var P5Time: UILabel!
    
    var procedureButtns:[UIButton] = []
    var allProcedures:[Procedure] = []
    
    //Additional vars
    var gameMatrix:[[String]] = []
    var frontDeskTableCellId = "frontDeskRecordCell"
    var archiveRecordCellId = "archiveRecordCell"
    var collectionCellId = "queueCell"
    
    var numPatients:Int = 0
    var maxRecordHoldTime:Int = 0
    
    var tick:Int = 0
    
    var allPatients:[Patient] = []
    var allPatientsCopy:[Patient] = []
    var nextPatients:[Patient] = []
    var patientLabels:[UILabel] = []
    var recordsBank:HealthRecordsBank = HealthRecordsBank(penalty: 0, frontDeskHoldTime: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontDeskTableView.delegate = self
        frontDeskTableView.dataSource = self
        
        archiveTableView.delegate = self
        archiveTableView.dataSource = self
        
        tickLabel.text = String(tick)
        
        //Set up columns
        col1 = [L11, L21, L31, L41, L51]
        col2 = [L12, L22, L32, L42, L52]
        col3 = [L13, L23, L33, L43, L53]
        col4 = [L14, L24, L34, L44, L54]
        col5 = [L15, L25, L35, L45, L55]
        
        patientLabels = [patient1, patient2, patient3, patient4, patient5]
        procedureButtns = [P1, P2, P3, P4, P5]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressNext(_ sender: Any) {
        tick += 1
        tickLabel.text = String(tick)
        movePatients()
        //Generate next patients
        populateNextPatients()
        //Reload stuff
        resizeLabels()
        frontDeskTableView.reloadData()
        archiveTableView.reloadData()
    }
    
    private func findPatientByName(name:String) -> Patient? {
        for patient in allPatientsCopy {
            if patient.name == name {
                return patient
            }
        }
        return nil
    }
    
    private func getArrayForProcedure(title:String) -> [UILabel]{
        switch title {
        case "P1":
            return col1
        case "P2":
            return col2
        case "P3":
            return col3
        case "P4":
            return col4
        default:
            return col5
        }
    }
    
    private func movePatients(){
        var moveIn:[String] = []
        //Add record holds to patients in procedures
        recordsBank.record(for: P1.titleLabel?.text ?? " ")?.holdTimeLeft += allProcedures[0].recordHoldTime
        recordsBank.record(for: P2.titleLabel?.text ?? " ")?.holdTimeLeft += allProcedures[1].recordHoldTime
        recordsBank.record(for: P3.titleLabel?.text ?? " ")?.holdTimeLeft += allProcedures[2].recordHoldTime
        recordsBank.record(for: P4.titleLabel?.text ?? " ")?.holdTimeLeft += allProcedures[3].recordHoldTime
        recordsBank.record(for: P5.titleLabel?.text ?? " ")?.holdTimeLeft += allProcedures[4].recordHoldTime
        
        //Move current patients in procedures to a temp "move-in" array
        for bttn in procedureButtns{
            if bttn.titleLabel?.text != "" {
                moveIn.append(bttn.titleLabel!.text!)
            }
        }
        P1.setTitle(" ", for: .normal)
        P2.setTitle(" ", for: .normal)
        P3.setTitle(" ", for: .normal)
        P4.setTitle(" ", for: .normal)
        P5.setTitle(" ", for: .normal)

        //Move patients by column
            //Column 1
        var patRecord = recordsBank.record(for: col1[0].text ?? "")
        if patRecord != nil {
            P1.setTitle(col1[0].text, for: UIControl.State.normal)
            var i = 1
            while i < 5 {
                col1[i-1].text = col1[i].text
                i += 1
            }
        }
            //Column2
        patRecord = recordsBank.record(for: col2[0].text ?? "")
        if patRecord != nil {
            P2.setTitle(col2[0].text, for: UIControl.State.normal)
            var i = 1
            while i < 5 {
                col2[i-1].text = col2[i].text
                i += 1
            }
        }
            //Column3
        patRecord = recordsBank.record(for: col3[0].text ?? "")
        if patRecord != nil {
            P3.setTitle(col3[0].text, for: UIControl.State.normal)
            var i = 1
            while i < 5 {
                col3[i-1].text = col3[i].text
                i += 1
            }
        }
            //Column4
        patRecord = recordsBank.record(for: col4[0].text ?? "")
        if patRecord != nil {
            P4.setTitle(col4[0].text, for: UIControl.State.normal)
            var i = 1
            while i < 5 {
                col4[i-1].text = col4[i].text
                i += 1
            }
        }
            //Column5
        patRecord = recordsBank.record(for: col5[0].text ?? "")
        if patRecord != nil {
            P5.setTitle(col5[0].text, for: UIControl.State.normal)
            var i = 1
            while i < 5 {
                col5[i-1].text = col5[i].text
                i += 1
            }
        }
        
        //Add "next patients" to "move-in" array
        for patient in nextPatients {
            moveIn.append(patient.name)
        }
        //Randomize "move-in" array
        moveIn.shuffle()
        //Add patients in "move-in" array to procedure lines
        for patientName in moveIn {
            //Find the patient object
            let patient = findPatientByName(name: patientName)
            //Check if patient has more procedures
            if patient != nil && patient!.hasMoreProcedures() {
                //Yes - move patient to end of respective line
                let procedureQueue = getArrayForProcedure(title: patient!.removeProcedure()!.title)
                for label in procedureQueue {
                    if label.text == "" {
                        label.text = patientName
                        break
                    }
                }
            }
        }
        
        recordsBank.tick()
    }
    
    @IBAction func didPressGenerate(_ sender: Any) {
        resetGameBoard()
        
        numPatients = Int(numPatientsTextBox.text!) ?? 0
        maxRecordHoldTime = Int(maxRecordHoldTextBox.text!) ?? 0
        recordsBank = HealthRecordsBank(penalty: Int.random(in: 0...maxRecordHoldTime), frontDeskHoldTime: Int.random(in: 0...maxRecordHoldTime))
        
        frontDeskTime.text = "(\(String(recordsBank.frontDeskHoldTime)))"
        archiveTime.text = "(\(String(recordsBank.archiveHoldPenalty)))"
        
        let procedure1:Procedure = Procedure(title: "P1", recordHoldTime: Int.random(in: 0...maxRecordHoldTime))
        let procedure2:Procedure = Procedure(title: "P2", recordHoldTime: Int.random(in: 0...maxRecordHoldTime))
        let procedure3:Procedure = Procedure(title: "P3", recordHoldTime: Int.random(in: 0...maxRecordHoldTime))
        let procedure4:Procedure = Procedure(title: "P4", recordHoldTime: Int.random(in: 0...maxRecordHoldTime))
        let procedure5:Procedure = Procedure(title: "P5", recordHoldTime: Int.random(in: 0...maxRecordHoldTime))
        allProcedures = [procedure1, procedure2, procedure3, procedure4, procedure5]
        
        P1Time.text = "(\(String(procedure1.recordHoldTime)))"
        P2Time.text = "(\(String(procedure2.recordHoldTime)))"
        P3Time.text = "(\(String(procedure3.recordHoldTime)))"
        P4Time.text = "(\(String(procedure4.recordHoldTime)))"
        P5Time.text = "(\(String(procedure5.recordHoldTime)))"

        var i = 0
        allPatients = []
        allPatientsCopy = []
        //Generate patients and grab their health records
        while i < numPatients {
            var patientProcedures:[Procedure] = []
            
            for _ in 0...5 {
                patientProcedures.append(allProcedures.randomElement()!)
            }
            
            let patient = Patient(name: "Patient \(i)", procedures: patientProcedures)
            allPatients.append(patient)
            allPatientsCopy.append(patient)
            recordsBank.archive.append(patient.healthRecord)
            
            i += 1
        }
        
        populateNextPatients()
        resizeLabels()
        frontDeskTableView.reloadData()
        archiveTableView.reloadData()
    }
    
    //Populate the next patients array
    private func populateNextPatients(){
        nextPatients = []
        var i = 0
        if allPatients.count == 0 {
            for label in patientLabels {
                label.text = ""
            }
            return
        }
        while (allPatients.count > 0 && i < 5) {
            nextPatients.append(allPatients.remove(at: 0))
            i += 1
        }
        
        i = 0
        for patient in nextPatients {
            patientLabels[i].text = patient.name
            i += 1
        }
        
    }
    //Change size of labels to fit including text
    private func resizeLabels() {
        for label in col1 {
            label.sizeToFit()
        }
        for label in col2 {
            label.sizeToFit()
        }
        for label in col3 {
            label.sizeToFit()
        }
        for label in col4 {
            label.sizeToFit()
        }
        for label in col5 {
            label.sizeToFit()
        }
        for label in patientLabels {
            label.sizeToFit()
        }
    }
    //Reset board
    private func resetGameBoard() {
        tick = 0
        tickLabel.text = String(tick)
        for label in col1 {
            label.text = ""
        }
        for label in col2 {
            label.text = ""
        }
        for label in col3 {
            label.text = ""
        }
        for label in col4 {
            label.text = ""
        }
        for label in col5 {
            label.text = ""
        }
        for label in patientLabels {
            label.text = ""
        }
        for bttn in procedureButtns {
            bttn.titleLabel?.text = ""
        }
    }
}
//Record Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.restorationIdentifier == "archiveRecordsTable"{
            return recordsBank.archive.count
        }
        else{
            return recordsBank.frontDesk.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.restorationIdentifier == "archiveRecordsTable" {
            let patRecord = recordsBank.archive[indexPath.row]
            let patient = findPatientByName(name: patRecord.patientName)!

            let cell = archiveTableView.dequeueReusableCell(withIdentifier: self.archiveRecordCellId)
            cell?.textLabel?.text = "\(patient.name) - \(patient.healthRecord.available) - HoldLeft: \(patient.healthRecord.holdTimeLeft)"
            return cell!
        }
        else{
            let patRecord = recordsBank.frontDesk[indexPath.row]
            let patient = findPatientByName(name: patRecord.patientName)!
            let cell = frontDeskTableView.dequeueReusableCell(withIdentifier: self.frontDeskTableCellId)
            cell?.textLabel?.text = "\(patient.name) - \(patient.healthRecord.available) - HoldLeft: \(patient.healthRecord.holdTimeLeft)(\(recordsBank.frontDeskLedger[patient.name]!))"
            cell?.textLabel?.sizeToFit()
            return cell!
        }
    }
}
