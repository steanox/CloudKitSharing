//
//  ContentView.swift
//  CloudKitSharing
//
//  Created by octavianus on 08/05/23.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    
    @StateObject var cloudKitManager = CloudKitManager()
    
    @State var isSharing = false
    @State var ckShare: CKShare?
    
    var body: some View {
        NavigationStack(root: {
            VStack{
                if cloudKitManager.isLoading{
                    ProgressView()
                }
                List(cloudKitManager.drawings) { drawing in
                    Text("\(drawing.title)")
                        .onTapGesture {
                            cloudKitManager.share(drawing: drawing)
                        }
                        
                }
                .refreshable {
                    Task {
                        await cloudKitManager.fetchAllDrawing()
                    }
                }
            }
            .navigationTitle("All Drawing")
            .toolbar {
                Button {
                    Task {
                        await cloudKitManager.addNewDrawing()
                    }
                } label: {
                    Image(systemName: "plus")
                }

            }
        })
        .onReceive(cloudKitManager.$sharedRecord, perform: { _ in
            if let _ = cloudKitManager.sharedRecord{
                isSharing = true
            }
        })
        .sheet(isPresented: $isSharing, content: {
            if let share = cloudKitManager.sharedRecord{
                SharingView(share: share)
            }
        })
        .onAppear{
            Task {
                await cloudKitManager.fetchAllDrawing()
            }
        }
        
        
        
    }
}

