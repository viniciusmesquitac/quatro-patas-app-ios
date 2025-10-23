//
//  AnnotationDetailsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 03/10/25.
//

import SwiftUI

struct AnnotationDetailsView: View {
    var annotation: Annotation
    var animalId: String
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var databaseProvider: DatabaseProvider
    @EnvironmentObject var userSession: UserSession
    @Environment(\.toast) var toast
    
    var path: String? {
        guard let userId = userSession.user?.id else { return nil }
        return "users/\(userId)/animals/\(animalId)/annotations"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.large.rawValue) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.primaryColor)
                    Text(formatDate(annotation.date))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()

                Text(annotation.text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Detalhes da Anotação")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .toolbarItem(icon: .delete, placement: .topBarTrailing, action: {
            let dialog = ConfirmDialogModel(
                title: "Deseja deletar essa anotação?",
                message: "Essa ação não pode ser desfeita.") {
                Task {
                    await delete(annotation)
                    navigator.dismiss()
                }
            }
            navigator.present(sheet: .confirmDelete(dialog))

        })
        .background(Color.customBackground)
    }
    
    private func formatDate(_ isoDate: String) -> String {
        if let date = ISO8601DateFormatter().date(from: isoDate) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return isoDate
    }
    
    @MainActor
    func delete(_ annotation: Annotation) async {
        guard let path = self.path, let id = annotation.id else { return }
        
        do {
            _ = try await databaseProvider.delete(from: path, id: id)
            toast("Anotação deletada", .success)
        } catch {
            toast("Erro ao deletar a anotação", .error)
        }
    }
}
