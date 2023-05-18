//
//  SharingView.swift
//  CloudKitSharing
//
//  Created by octavianus on 09/05/23.
//

import Foundation
import CloudKit
import SwiftUI

struct SharingView: UIViewControllerRepresentable{
    
    var share: CKShare
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let cloudSharing = UICloudSharingController(
            share: share,
            container: CloudKitConfiguration.container
        )
        cloudSharing.availablePermissions = [.allowPublic,.allowPrivate,.allowReadWrite]
        
        return cloudSharing
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
