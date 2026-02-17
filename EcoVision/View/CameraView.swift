//
//  CameraView.swift
//  EcoVision
//

import SwiftUI
import PhotosUI

struct CameraView: View {

    @StateObject private var vm = CameraViewModel()

    @State private var selectedItem: PhotosPickerItem?
    @State private var showScanCamera = false
    @State private var showLiveCamera = false

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    var body: some View {

        ZStack {

            // MARK: Layered Premium Background
            ZStack {

                LinearGradient(
                    colors: [
                        Color(red: 0.93, green: 0.96, blue: 0.95),
                        Color(red: 0.82, green: 0.88, blue: 0.85)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                RadialGradient(
                    colors: [
                        Color.green.opacity(0.18),
                        Color.clear
                    ],
                    center: .topTrailing,
                    startRadius: 50,
                    endRadius: 600
                )
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header
                HStack {

                    Button {
                        dismiss()
                    } label: {

                        ZStack {

                            Circle()
                                .fill(Color.white.opacity(0.55))
                                .frame(width: 44, height: 44)

                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black.opacity(0.75))
                        }
                    }

                    Spacer()

                    Text("ECOVISION")
                        .font(.system(size: 18, weight: .semibold))
                        .kerning(4)
                        .foregroundColor(.black.opacity(0.65))

                    Spacer()

                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer().frame(height: 40)

                // MARK: Cards
                VStack(spacing: 24) {

                    // Pick Image
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {

                        FeatureCard(
                            title: "Pick Image",
                            subtitle: "Upload from gallery",
                            gradient: [
                                Color(red: 0.35, green: 0.60, blue: 0.95),
                                Color(red: 0.40, green: 0.75, blue: 0.85)
                            ],
                            icon: "photo"
                        )
                    }
                    .onChange(of: selectedItem) { newItem in

                        Task {

                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {

                                vm.classifyImage(image)
                            }
                        }
                    }

                    // Scan Image
                    Button {

                        showScanCamera = true

                    } label: {

                        FeatureCard(
                            title: "Scan Image",
                            subtitle: "Capture trash directly",
                            gradient: [
                                Color(red: 0.45, green: 0.75, blue: 0.45),
                                Color(red: 0.40, green: 0.75, blue: 0.65)
                            ],
                            icon: "viewfinder"
                        )
                    }

                    // Live Detection
                    Button {

                        showLiveCamera = true

                    } label: {

                        FeatureCard(
                            title: "Live Detection",
                            subtitle: "Real-time analysis",
                            gradient: [
                                Color(red: 0.95, green: 0.60, blue: 0.30),
                                Color(red: 0.95, green: 0.80, blue: 0.30)
                            ],
                            icon: "camera.viewfinder"
                        )
                    }
                }

                Spacer()

                NavigationLink(
                    destination: ResultView(result: vm.result),
                    isActive: $vm.isShowingResult
                ) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)

        // Scan Camera Sheet
        .sheet(isPresented: $showScanCamera) {

            CameraCaptureView { image in
                vm.classifyImage(image)
            }
        }

        // Live Detection Sheet
        .sheet(isPresented: $showLiveCamera) {

            ZStack {

                LiveCameraView(viewModel: vm)

                VStack {

                    Spacer()

                    if let result = vm.result {

                        Text("\(result.label) \(Int(result.confidence * 100))%")
                            .font(.title3)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.bottom, 40)
                    }
                }
            }
        }
    }
}

