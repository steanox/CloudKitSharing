//
//  CloudKitManager.swift
//  CloudKitSharing
//
//  Created by octavianus on 08/05/23.
//

import Foundation
import CloudKit
import SwiftUI


class CloudKitManager: NSObject,ObservableObject{
    
    @Published var drawings: [Drawing] = []
    @Published var sharedRecord: CKShare?
    @Published var isLoading: Bool = false
    
    public func fetchAllDrawing() async {
        DispatchQueue.main.async { self.isLoading = true }
        
        if let drawings = await Drawing.getAllDrawingFromCloudKit(){
            DispatchQueue.main.async {
                self.isLoading = false
                self.drawings = drawings }
        }else{
            self.isLoading = false
        }
    }
    
   
    
    public func share(drawing: Drawing){
        self.sharedRecord = drawing.shareDrawing()
    }
    
    public func addNewDrawing() async {
        DispatchQueue.main.async { self.isLoading = true }
    
        let newDrawing = Drawing(title: "Untitled Drawing \(drawings.count + 1)")
        
        if let savedDrawing = await newDrawing.saveNewDrawingToCloudKit(){
            
            DispatchQueue.main.async {
                self.drawings.append(savedDrawing)
                self.isLoading = false
                
            }
        }else{
            DispatchQueue.main.async { self.isLoading = false }
        }
    }
}

extension CloudKitManager: UICloudSharingControllerDelegate{
    func itemTitle(for csc: UICloudSharingController) -> String? {
        return "Item"
    }
    
    func cloudSharingControllerDidSaveShare(_ csc: UICloudSharingController) {
        
    }
    
    func cloudSharingControllerDidStopSharing(_ csc: UICloudSharingController) {
        
    }
    
    func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
        
    }
}
