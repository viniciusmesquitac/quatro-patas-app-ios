//
//  WeightChartView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/10/25.
//

import SwiftUI
import Charts

struct WeightChartView: View {
    @State private var entries: [WeightEntry] = []
    @State private var selected: WeightEntry?
    @State private var showDeleteDialog = false
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var databaseProvider: DatabaseProvider
    
    @State private var isLoading: Bool = false
    @Environment(\.toast) var toast
    
    var animalId: String
    
    var chartView: some View {
        Chart(entries) { entry in
            LineMark(
                x: .value("Data", entry.date),
                y: .value("Peso", entry.weight)
            )
            .symbol(Circle())
            .foregroundStyle(Color.primaryColor)
            
            if selected?.id == entry.id {
                PointMark(
                    x: .value("Data", entry.date),
                    y: .value("Peso", entry.weight)
                )
                .foregroundStyle(.red)
            }
        }
        .frame(height: 250)
        .padding()
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                if let date: Date = proxy.value(atX: value.location.x) {
                                    if let nearest = entries.min(by: {
                                        abs($0.date.timeIntervalSince(date)) <
                                        abs($1.date.timeIntervalSince(date))
                                    }) {
                                        selected = nearest
                                        showDeleteDialog = true
                                    }
                                }
                            }
                    )
            }
        }
    }
    
    var body: some View {
        VStack {
            if entries.isEmpty {
                Text("Nenhum registro de peso ainda")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    Section {
                        chartView
                    }
                    
                    ForEach(entries) { entry in
                        HStack {
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            Text("\(entry.weight, specifier: "%.1f") kg")
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let entry = entries[index]
                            Task { await delete(entry) }
                        }
                    }
                }
            }
        }
        .task {
            await fetch(from: animalId)
        }
        .navigationTitle("Histórico de Peso")
        .navigationBarBackButtonHidden()
        .toolbarItem(icon: .back, placement: .topBarLeading) {
            navigator.dismiss()
        }
        .toolbarItem(icon: .add, placement: .topBarTrailing) {
            navigator.present(sheet: .addWeight(animalId: animalId, onAdded: { weight in
                entries.append(weight)
            }))
        }
        // --- CONFIRMATION DIALOG ---
        .confirmationDialog("Deletar registro?", isPresented: $showDeleteDialog, titleVisibility: .visible) {
            if let selected {
                Button("Deletar", role: .destructive) {
                    Task { await delete(selected) }
                }
            }
            Button("Cancelar", role: .cancel) {}
        }
    }
    
    @MainActor
    func fetch(from animalId: String) async {
        do {
            isLoading = true
            guard let userId = userSession.user?.id else { return }
            let path = "users/\(userId)/animals/\(animalId)/weights"
            
            let items: [WeightEntry] = try await databaseProvider.fetch(from: path)
            entries = items.sorted { $0.date < $1.date }
            
            isLoading = false
        } catch {
            toast("Erro ao carregar os registros de peso", .error)
        }
    }
    
    @MainActor
    func delete(_ entry: WeightEntry) async {
        guard let userId = userSession.user?.id,
              let id = entry.id else { return }
        
        withAnimation {
            entries.removeAll { $0.id == id }
        }
        
        do {
            let path = "users/\(userId)/animals/\(animalId)/weights"
            _ = try await databaseProvider.delete(from: path, id: id)
            toast("Peso deletado com sucesso", .success)
        } catch {
            toast("Erro ao deletar peso", .error)
        }
    }
}
