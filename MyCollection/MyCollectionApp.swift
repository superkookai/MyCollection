//
//  MyCollectionApp.swift
//  MyCollection
//
//  Created by Weerawut Chaiyasomboon on 11/03/2568.
//

import SwiftUI
import SwiftData

@main
struct MyCollectionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: MyCollection.self)
        }
    }
}
