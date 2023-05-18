//
//  CloudKitConfiguration.swift
//  CloudKitSharing
//
//  Created by octavianus on 09/05/23.
//

import Foundation
import CloudKit

struct CloudKitConfiguration{
    static let container = CKContainer(identifier: "iCloud.TestUser")
    private init(){}
}
