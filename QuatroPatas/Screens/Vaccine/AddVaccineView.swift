//
//  AddVaccineView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 25/09/25.
//

import SwiftUI

struct AddVaccineView: View {
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var databaseProvider: DatabaseProvider
    
    @Environment(\.toast) var toast
    
    var animalId: String
    
    var vaccinePath: String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals/\(animalId)/vaccines"
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
            // Vacina
            Section(header: Text("Vacina")) {
                HStack {
                    Text("Nome")
                    Spacer()
                    VaccinePicker(selectedVaccine: $selectedVaccine)
                        .labelsHidden()
                        .frame(maxWidth: 120)
                }
                
                if selectedVaccine == "Outro" {
                    HStack {
                        Text("Personalizado")
                        Spacer()
                        TextField("Digite o nome", text: $customName)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 150)
                    }
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
            
            // Datas
            Section(header: Text("Datas")) {
                DatePicker("Data da Aplicação", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                DatePicker("Próxima aplicação", selection: $nextDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            
            // Notificações
            Section(header: Text("Notificações")) {
                NotificationOptionsSelector(
                    sendNotification: $sendNotification,
                    selectedOptions: $selectedNotificationOptions
                )
            }
        }
        .navigationTitle("Adicionar Vacina")
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
        
        let resolvedName = (selectedVaccine == "Outro" ? customName.trimmingCharacters(in: .whitespacesAndNewlines) : selectedVaccine)?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let name = resolvedName else {
            toast("Informe o nome da vacina", .error)
            isLoading = false
            return
        }
        
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
        
        let vaccine = Vaccine(
            name: name,
            customName: (selectedVaccine == "Outro" ? resolvedName : nil),
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
                _ = try await databaseProvider.add(vaccine, to: path)
                isLoading = false
                toast("Vacina adicionada com sucesso!", .success)
                onAdded()
                navigator.dismiss()
            } catch {
                isLoading = false
                toast(error.localizedDescription, .error)
            }
        }
    }
    
    
}
