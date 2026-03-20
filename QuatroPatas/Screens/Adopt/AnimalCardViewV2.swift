//
//  AnimalCardView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 20/03/26.
//
import SwiftUI

struct AnimalCardViewV2: View {
    let animal: Animal
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    AnimalCardImageSection(photoURL: animal.photos.first)

                    HStack {
                        Spacer()
                        if let animalId = animal.id {
                            FavoriteCircleButton(animalId: animalId)
                        }
                    }
                    .padding(12)
                }
                .frame(height: 190)
                .clipped()

                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 8) {
                        Text(animal.name.isEmpty ? "Sem nome" : animal.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Spacer(minLength: 4)

                        Text(formattedAge)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(2)
                    }

                    HStack(spacing: 6) {
                        SFIcon.image(.pin, color: .secondary)
                            .font(.system(size: 14))

                        Text(animalLocation)
                            .font(.system(size: 15))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.customBackground)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.black.opacity(0.04), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var formattedAge: String {
        animal.age.isEmpty ? "Idade não informada" : animal.simplifiedAge
    }

    private var animalLocation: String {
        "Fortaleza-CE"
    }
}

struct AnimalCardImageSection: View {
    let photoURL: String?

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let photoURL,
                   let url = URL(string: photoURL) {
                    CachedAsyncImage(url: url)
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.12))
                        .overlay {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.secondary)
                        }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
        .frame(height: 190)
        .clipped()
    }
}
