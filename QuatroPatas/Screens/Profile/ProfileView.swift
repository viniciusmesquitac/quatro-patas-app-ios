//
//  ProfileView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/09/25.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var userSession: UserSession

    private var memberSinceText: String {
        guard let date = userSession.user?.createdAt else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd 'de' MMMM 'de' yyyy"
        return "Membro desde \(formatter.string(from: date))"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerSection
                infoCard
                if userSession.user?.type == .ngo {
                    if let description = userSession.user?.description, !description.isEmpty {
                        aboutCard(description: description)
                    }
                    formsCard
                }
                footerButtons
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Perfil")
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 10) {
            if let photo = userSession.user?.photo, let url = URL(string: photo) {
                CachedAsyncImage(url: url)
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
            } else {
                Image("default-profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
            }

            Text(userSession.user?.name ?? "Anônimo")
                .font(.title2)
                .fontWeight(.bold)

            HStack(spacing: 8) {
                if userSession.user?.type == .ngo {
                    typeBadge("🏠 ONG", background: Color.primaryColor, foreground: .white)
                    typeBadge("✓ Aprovada", background: Color.green.opacity(0.15), foreground: Color(red: 0.1, green: 0.6, blue: 0.3))
                } else {
                    typeBadge(userSession.user?.type.localized ?? "", background: Color.primaryColor, foreground: .white)
                }
            }

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(memberSinceText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 24)
    }

    // MARK: - Info Card

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Informações")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    if let user = userSession.user {
                        navigator.navigate(to: .personalInformation(user))
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Editar")
                    }
                    .foregroundColor(.primaryColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            VStack(spacing: 0) {
                infoRow(icon: .envelope, label: "E-mail", value: userSession.user?.email)
                if let cnpj = userSession.user?.cnpj, !cnpj.isEmpty {
                    Divider().padding(.leading, 68)
                    infoRow(icon: .building, label: "CNPJ", value: cnpj)
                }
                if let location = userSession.user?.location, !location.isEmpty {
                    Divider().padding(.leading, 68)
                    infoRow(icon: .pin, label: "Localização", value: location)
                }
                if let phone = userSession.user?.phone, !phone.isEmpty {
                    Divider().padding(.leading, 68)
                    infoRow(icon: .phone, label: "Telefone", value: phone)
                }
                if let instagram = userSession.user?.instagram, !instagram.isEmpty {
                    Divider().padding(.leading, 68)
                    infoRow(icon: .instagram, label: "Instagram", value: instagram)
                }
                if userSession.user?.type == .ngo {
                    if let pix = userSession.user?.pixKey, !pix.isEmpty {
                        Divider().padding(.leading, 68)
                        infoRow(icon: .pix, label: "Chave Pix", value: pix)
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - About Card

    private func aboutCard(description: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Sobre a ONG")
                .font(.headline)
                .fontWeight(.bold)
            Text(description)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("📋")
                    .font(.title3)
                Text("Formulários de Adoção")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            VStack(spacing: 8) {
                formRow(emoji: "🐶", title: "Formulário para Cães", urlString: userSession.user?.formDog)
                formRow(emoji: "🐱", title: "Formulário para Gatos", urlString: userSession.user?.formCat)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Footer Buttons

    private var footerButtons: some View {
        VStack(spacing: 16) {
            Button {
                navigator.present(sheet: .logout)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                    Text("Sair da conta")
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.red, lineWidth: 1.5)
                )
            }

            Button {
                navigator.present(sheet: .deleteAccount(onDelete: { _ in }))
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "trash")
                    Text("Deletar conta")
                }
                .foregroundColor(.red)
                .font(.callout)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Helpers

    private func typeBadge(_ text: String, background: Color, foreground: Color) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(foreground)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(background)
            .cornerRadius(20)
    }

    private enum InfoIcon {
        case envelope, building, pin, phone, instagram, pix

        var systemName: String {
            switch self {
            case .envelope: return "envelope"
            case .building: return "building.2"
            case .pin: return "mappin.and.ellipse"
            case .phone: return "phone"
            case .instagram: return "camera"
            case .pix: return "qrcode"
            }
        }
    }

    private func infoRow(icon: InfoIcon, label: String, value: String?) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.primaryColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: icon.systemName)
                    .foregroundColor(.primaryColor)
                    .font(.system(size: 18))
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value ?? "—")
                    .font(.body)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private func formRow(emoji: String, title: String, urlString: String?) -> some View {
        let hasURL = urlString != nil && !urlString!.isEmpty
        return HStack {
            Text(emoji)
                .font(.title3)
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            if hasURL {
                Image(systemName: "link")
                    .foregroundColor(.secondary)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .onTapGesture {
            if let urlString, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
}
