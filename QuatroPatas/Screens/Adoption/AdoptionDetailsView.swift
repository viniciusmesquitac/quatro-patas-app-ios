//
//  AdoptionDetailsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 26/09/25.
//

import SwiftUI

struct AdoptionDetailsView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    
    var animalId: String
    
    @State private var adoption: Adoption?
    @State private var isLoading = true
    @State private var showImageFullScreen = false
    
    @State private var selectedImageURL: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge.rawValue) {
                
                if let adoption {
                    VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                        Text("Foto da Identidade (frente e verso)")
                            .font(.headline)
                        
                        HStack {
                            if let stringURL = adoption.idPhotoFront,
                               let idPhotoFrontURL = URL(string: stringURL) {
                                imageThumbnail(idPhotoFrontURL)
                            }
                            
                            if let stringURL = adoption.idPhotoBack,
                               let idPhotoBackURL = URL(string: stringURL) {
                                imageThumbnail(idPhotoBackURL)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                        Text("Foto do Termo de Adoção Assinado")
                            .font(.headline)
                        if let stringURL = adoption.termPhoto,
                           let imageUrl = URL(string: stringURL) {
                            imageThumbnail(imageUrl)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                        Text("Status")
                            .font(.headline)
                        Text(adoption.status.rawValue.capitalized)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Informações da Adoção")
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .task {
            await loadAdoption()
        }
        .onChange(of: selectedImageURL) {
            showImageFullScreen = true
        }
        .fullScreenCover(isPresented: $showImageFullScreen) {
            if let url = selectedImageURL {
                FullScreenImageView(imageURL: url) {
                    showImageFullScreen = false
                }
            }
        }
    }
    
    private func loadAdoption() async {
        do {
            let adoptions: [Adoption] = try await databaseProvider.fetch(
                from: "adoptions",
                query: { ref in
                    ref.whereField("animalId", isEqualTo: animalId)
                }
            )
            adoption = adoptions.first
        } catch {
            print("Erro ao carregar adoção: \(error)")
        }
        isLoading = false
    }
    
    @ViewBuilder
    private func imageThumbnail(_ url: URL) -> some View {
        CachedAsyncImage(url: url)
            .scaledToFill()
            .clipped()
            .frame(width: 100, height: 150)
            .onTapGesture {
                selectedImageURL = url
                showImageFullScreen = true
            }
    }
}
struct DisabledToggleRow: View {
    var title: String
    var value: Bool
    
    var body: some View {
        HStack {
            Toggle(title, isOn: .constant(value))
                .disabled(true)
        }
    }
}

