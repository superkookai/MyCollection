//
//  MyCollection.swift
//  MyCollection
//
//  Created by Weerawut Chaiyasomboon on 11/03/2568.
//

import Foundation
import SwiftData

@Model
class MyCollection {
    var name: String
    
    @Attribute(.externalStorage)
    var photo: Data?
    
    init(name: String, photo: Data? = nil) {
        self.name = name
        self.photo = photo
    }
}

@MainActor
extension MyCollection {
    static var previews: ModelContainer {
        let container = try! ModelContainer(for: MyCollection.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(MyCollection(name: "Scene Paintings"))
        container.mainContext.insert(MyCollection(name: "People Stamp"))
        container.mainContext.insert(MyCollection(name: "Thai old coins"))
        
        return container
    }
}
