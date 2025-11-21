//
//  RegisterAdoption.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

import SwiftUI
import PhotosUI

struct RegisterAdoption: View {
    
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var storageProvider: StorageProvider
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    
    var animalId: String
    
    @Environment(\.toast) var toast
    
    @State private var idFrontImage: UIImage?
    @State private var idBackImage: UIImage?
    @State private var adoptionTermImage: UIImage?
    
    // Checklist
    @State private var escapeRoutesChecked = false
    @State private var safePlaceChecked = false
    @State private var restAreaChecked = false
    @State private var currentUploadIndex = 0

    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge.rawValue) {
                
                Text("Registro de Adoção")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Fotos RG/CPF
                VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                    Text("Foto da Identidade (frente e verso)")
                        .font(.headline)
                    
                    HStack {
                        PhotoUploadView(title: "Frente", image: $idFrontImage)
                        PhotoUploadView(title: "Verso", image: $idBackImage)
                    }
                }
                
                // Foto Termo de Adoção
                VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                    Text("Foto do Termo de Adoção Assinado")
                        .font(.headline)
                    
                    PhotoUploadView(title: "Adicionar", image: $adoptionTermImage)
                }
                
                // Checklist
                VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                    Text("Checklist de Verificação")
                        .font(.headline)
                    
                    Toggle("Rotas de fuga verificadas", isOn: $escapeRoutesChecked)
                    Toggle("Local seguro avaliado", isOn: $safePlaceChecked)
                    Toggle("Espaço de descanso apropriado", isOn: $restAreaChecked)
                }
                .toggleStyle(.switch)
                
                Button("Registrar Adoção") {
                    registerAdoption()
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top, Padding.large.rawValue)
                
            }
            .navigationBarBackButtonHidden(true)
            .toolbarItem(icon: .back, placement: .topBarLeading, action: {
                navigator.dismiss()
            })
            .navigationBarHidden(isLoading)
            .padding()
        }
        .overlay {
            if isLoading {
                LoadingCatView(currentUploadIndex: currentUploadIndex, totalItems: 3)
            }
        }
    }
    
    // MARK: - Registrar
    private func registerAdoption() {
        isLoading = true
        
        Task {
            do {
                try await sendAdoption()
            } catch {
                isLoading = false
                toast("Erro ao registrar adoção", .error)
            }
        }
    }
    
    private func sendAdoption() async throws {
        guard let termPhoto = adoptionTermImage,
              let idFront = idFrontImage,
              let idBack = idBackImage else {
            toast("Faltam fotos obrigatórias", .error)
            isLoading = false
            return
        }

        let termPath = "adoptions/terms/\(UUID().uuidString).jpg"
        let idFrontPath = "adoptions/rg/\(UUID().uuidString).jpg"
        let idBackPath = "adoptions/rg/\(UUID().uuidString).jpg"
        
        guard let compressedTermPhoto = termPhoto.compressed(),
           let compressedIdFront = idFront.compressed(),
           let compressedIdBack = idBack.compressed() else {
            return
        }

        let termURL = try await storageProvider.uploadFile(
            data: compressedTermPhoto,
            path: termPath
        )

        toast("foto de termo de responsabilidade carregada!", .success)

        let idFrontURL = try await storageProvider.uploadFile(
            data: compressedIdFront,
            path: idFrontPath
        )
    
        let idBackURL = try await storageProvider.uploadFile(
            data: compressedIdBack,
            path: idBackPath
        )

        toast("fotos da identidade carregadas", .success)
    
        guard let ongId = userSession.user?.id else {
            toast("Não foi possivel concluir essa requisição, tente novamente.", .error)
            return
        }

        let adoption = Adoption(
            animalId: animalId,
            termPhoto: termURL.absoluteString,
            idPhotoFront: idFrontURL.absoluteString,
            idPhotoBack: idBackURL.absoluteString,
            status: .approved
        )

        _ = try await databaseProvider.add(adoption, to: "users/\(ongId)/adoptions")
        
        _ = try await databaseProvider.updateFields(
            in: "users/\(ongId)/animals",
            id: animalId,
            fields: ["isAdopted": true]
        )

        isLoading = false
        navigator.popToRoot()
        toast("Adoção registrada com sucesso!", .success)
    }

}
