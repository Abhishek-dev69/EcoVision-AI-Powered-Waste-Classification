//
//  CameraView.swift
//  EcoVision
//
//  Created by Abhishek on 12/02/26.
//

import SwiftUI
import PhotosUI

struct CameraView: View {

    @StateObject private var vm = CameraViewModel()
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 20) {

            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                Text("Pick Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        vm.classifyImage(image)
                    }
                }
            }

            NavigationLink(
                destination: ResultView(result: vm.result),
                isActive: $vm.isShowingResult
            ) {
                EmptyView()
            }
        }
        .navigationTitle("Scan Waste")
        .padding()
    }
}
