//
//  ImagePickerView.swift
//  AmazingRecipes
//
//  Created by Igor Silva on 01/06/23.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var selectedImageData: Data?
    
    var body: some View {
        
        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Selecione uma imagem")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
    }
}
