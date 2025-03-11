//
//  ContentView.swift
//  MyCollection
//
//  Created by Weerawut Chaiyasomboon on 11/03/2568.
//

import SwiftUI
import SwiftData

enum SheetAction: Identifiable {
    case add
    case edit(MyCollection)
    
    var id: Int {
        switch self {
        case .add:
            return 1
        case .edit:
            return 2
        }
    }
}

struct Constants {
    static let screenWidth = (UIScreen.main.bounds.width / 2) - 30
}

struct ContentView: View {
    
    let columns = [GridItem(.flexible(minimum: 0, maximum: Constants.screenWidth),spacing: 10),GridItem(.flexible(minimum: 0, maximum: Constants.screenWidth),spacing: 10)]
    
    @Query private var collections: [MyCollection] = []
    
    @State private var sheetAction: SheetAction?
    
    var body: some View {
        NavigationStack {
            Group {
                if collections.isEmpty {
                    ContentUnavailableView("No collections in database", systemImage: "swiftdata")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns,spacing: 15) {
                            ForEach(collections) { collection in
                                CollectionView(collection: collection)
                                    .contentShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        sheetAction = .edit(collection)
                                    }
                            }
                        }
                        .padding(.horizontal,10)
                    }
                }
            }
            .navigationTitle("My Collections")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetAction = .add
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.black)
                    }

                }
            }
            .sheet(item: $sheetAction) { sheetAction in
                switch sheetAction {
                case .add:
                    AddEditCollectionView()
                case .edit(let myCollection):
                    AddEditCollectionView(editCollection: myCollection)
                }
            }
        }
    }
}

#Preview("Empty Data") {
    ContentView()
        .modelContainer(for: MyCollection.self, inMemory: true)
}

#Preview("Sample Data") {
    ContentView()
        .modelContainer(MyCollection.previews)
}

struct CollectionView: View {
    let collection: MyCollection
    
    var body: some View {
        VStack {
            if let imageData = collection.photo, let uiImage = UIImage(data: imageData) {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.screenWidth, height: 200)
                    .clipShape(.rect(cornerRadius: 10))
                    
            } else {
                VStack {
                    Image(systemName: "star.square.on.square")
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            }
            
            Text(collection.name)
                .fontWeight(.semibold)
                .lineLimit(1)
                .padding(.bottom)
        }
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
        )
    }
}
