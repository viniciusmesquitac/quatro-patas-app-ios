//
//  NGODetailsView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//

import SwiftUI

struct NGODetailsView: View {

    @State var ngo: User
    @EnvironmentObject var navigator: Navigator
    
    var image: some View {
        ZStack(alignment: .bottom) {
            if let firstURL = ngo.photo,
               let url = URL(string: firstURL) {
                CachedAsyncImage(url: url)
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .clipped()
                    .stretchy()
            }
        }
        .background(Color(uiColor: .systemBackground))
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: Spacing.small.rawValue) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        image
                    }

                    VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {

                        Text(ngo.name + ", " + (ngo.instagram ?? String()))
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        if let description = ngo.description {
                            Text(description)
                                .padding(.top)
                        }

                        Spacer()
                        
                        Button("Apoiar esta ONG") {
                            navigator.present(sheet: .donate(pixKey: "ong-chave-pix", merchantName: ngo.name, merchantCity: ngo.location ?? "FORTALEZA"))
                        }
                        .buttonStyle(PrimaryButtonStyle())

                    }
                    .padding()
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(edges: .top)
        }
    }
}
