//
//  AddEditCollectionView.swift
//  MyCollection
//
//  Created by Weerawut Chaiyasomboon on 11/03/2568.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddEditCollectionView: View {
    var editCollection: MyCollection?
    
    @State private var name: String = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    var hasEdit: Bool {
        editCollection != nil
    }
    
    private func saveOrEdit() {
        if let editCollection {
            editCollection.name = self.name
            editCollection.photo = self.photoData
        } else {
            let newCollection = MyCollection(name: self.name, photo: self.photoData)
            context.insert(newCollection)
        }
        
        do {
            try context.save()
        } catch {
            print("Error save MyCollection: \(error)")
        }
        
        dismiss()
    }
    
    private var isFormValid: Bool {
        !name.isEmpty
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text(hasEdit ? "Update Collection" : "Add Collection")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            TextField("Collection Name", text: $name)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.horizontal)
            
            PhotosPicker(selection: $photoItem) {
                Label("Select Photo", systemImage: "photo.artframe")
                    .padding(.vertical)
                    .foregroundStyle(.black)
            }
            
            if let data = photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding()
                
            } else {
                VStack {
                    Image(systemName: "photo.artframe")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                )
                .padding()
            }
            
            Button {
                saveOrEdit()
            } label: {
                Text(hasEdit ? "Update" : "Save")
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isFormValid ? .green : .gray.opacity(0.5))
                    .clipShape(.rect(cornerRadius: 10))
                    .padding(.horizontal)
            }
            .disabled(!isFormValid)
            
            Spacer()
        }
        .onChange(of: photoItem) {
            Task {
                self.photoData = try? await photoItem?.loadTransferable(type: Data.self)
            }
        }
        .onAppear {
            if let editCollection {
                self.name = editCollection.name
                self.photoData = editCollection.photo
            }
        }
    }
}

#Preview {
    AddEditCollectionView()
        .modelContainer(for: MyCollection.self, inMemory: true)
}
