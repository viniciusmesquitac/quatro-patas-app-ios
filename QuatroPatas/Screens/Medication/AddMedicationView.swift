//
//  AddMedicationView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/10/25.
//

import SwiftUI

struct AddMedicationView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var firestoreProvider: FirestoreProvider
    
    @Environment(\.toast) var toast
    
    var animalId: String
    
    var vaccinePath: String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals/\(animalId)/medications"
    }

    var onAdded: (() -> Void)

    @State private var selectedVaccine: String? = nil
    @State private var customName: String = ""
    @State private var laboratory: String = ""
    @State private var doseNumber: String = ""
    @State private var date: Date = Date()
    @State private var nextDate: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var sendNotification: Bool = false
    @State private var notificationOption: NotificationOption = .onTheDay
    @State private var selectedNotificationOptions: Set<NotificationOption> = []
    
    @State private var isLoading: Bool = false
    
    
    var body: some View {
        Form {
            Section(header: Text("Medicação")) {
                HStack {
                    Text("Nome")
                    Spacer()
                    TextField("Digite o nome", text: $customName)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 150)
                }
                
                HStack {
                    Text("Laboratório")
                    Spacer()
                    TextField("Opcional", text: $laboratory)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 150)
                }
                
                HStack {
                    Text("Dose nº")
                    Spacer()
                    TextField("Ex: 1, 2, Reforço", text: $doseNumber)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 150)
                }
            }
            
            Section(header: Text("Datas")) {
                DatePicker("Data da Aplicação", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                DatePicker("Próxima aplicação", selection: $nextDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
    
            Section(header: Text("Notificações")) {
                NotificationOptionsSelector(
                    sendNotification: $sendNotification,
                    selectedOptions: $selectedNotificationOptions
                )
            }
        }
        .navigationTitle("Adicionar Medicação")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(label: "Fechar") {
            navigator.dismiss()
        }
        .safeAreaInset(edge: .bottom) {
            Button("Adicionar") {
                saveVaccine()
            }
            .padding(.horizontal, Padding.large.rawValue)
            .padding(.vertical, Padding.medium.rawValue)
            .buttonStyle(PrimaryButtonStyle(isLoading: isLoading))
        }
    }
    
    private func saveVaccine() {
        guard let path = vaccinePath else {
            toast("Erro ao salvar: caminho inválido", .error)
            return
        }
        
        isLoading = true
        
        let resolvedName = customName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !resolvedName.isEmpty else {
            toast("Informe o nome da medication", .error)
            isLoading = false
            return
        }
        
        // converte doseNumber (String) para Int?
        let doseNumberInt: Int? = {
            let trimmed = doseNumber.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : Int(trimmed)
        }()
        
        let totalDosesInt: Int? = nil
        
        let nextDateString: String? = {
            if Calendar.current.isDate(date, inSameDayAs: nextDate) {
                return nil
            } else {
                return ISO8601DateFormatter().string(from: nextDate)
            }
        }()
        
        let dateString = ISO8601DateFormatter().string(from: date)
        
        let medication = Medication(
            name: customName,
            laboratory: laboratory.isEmpty ? nil : laboratory,
            doseNumber: doseNumberInt,
            totalDoses: totalDosesInt,
            date: dateString,
            nextDate: nextDateString,
            sendNotification: sendNotification,
            notificationOption: sendNotification ? notificationOption : nil
        )
        
        Task {
            do {
                _ = try await firestoreProvider.add(medication, to: path)
                isLoading = false
                toast("Medicação adicionada com sucesso!", .success)
                onAdded()
                navigator.dismiss()
            } catch {
                isLoading = false
                toast(error.localizedDescription, .error)
            }
        }
    }
    
    
}
