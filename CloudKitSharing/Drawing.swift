//
//  Drawing.swift
//  CloudKitSharing
//
//  Created by octavianus on 08/05/23.
//

import Foundation
import CloudKit

struct Drawing: Identifiable{
    var id = UUID()
    var title: String
    var date: Date = Date()
    
    
    
    
    var record: CKRecord?
    
    
    private var newRecord: CKRecord {
        let record = CKRecord(recordType: "Drawing")
        record.setValuesForKeys([
            "title": self.title
        ])
        return record
    }
    
    public func saveNewDrawingToCloudKit() async  -> Drawing?{
        let database = CloudKitConfiguration.container.privateCloudDatabase
        let newRecord = newRecord
        
        do{
            try await database.save(newRecord)
            return self
        }catch let err{
            print("Error cloudkit \(err.localizedDescription)")
            return nil
        }
    }
    
    
    
    static public func getAllDrawingFromCloudKit() async -> [Drawing]? {
        let database = CloudKitConfiguration.container.privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "drawing", predicate: predicate)
        
        do{
            let resultRecords = try await database.records(matching: query, desiredKeys: nil)
            
            let drawings = try resultRecords.matchResults.map({ (id,result) in
                let record = try result.get()
                var drawing = Drawing(title: record["title"] as! String)
                drawing.record = record
                return drawing
            })
            
            return drawings
            
        }catch let err{
            print("Error cloudkit add \(err.localizedDescription)")
            return nil
        }
    }
    
    
    
    
    
    
    
    public func shareDrawing() -> CKShare{
        let shareRecord = CKShare(rootRecord: self.record!, shareID: self.record!.recordID)
        shareRecord[CKShare.SystemFieldKey.title] = "Share \(self.title)" as CKRecordValue
        shareRecord.publicPermission = .readWrite
        return shareRecord
        
    }
}
