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
    @Environment(\.toast) var toast
    
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
    
    var isEnabled: Bool {
        !(ngo.pixKey ?? String()).isEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: Spacing.small.rawValue) {
                    
                    ZStack(alignment: .bottomTrailing) {
                        image
                    }
                    
                    VStack(alignment: .center) {
                        Text(ngo.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(ngo.location ?? "")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                    }

                    VStack(alignment: .leading, spacing: Spacing.medium.rawValue) {
                        
                        VStack(alignment: .leading, spacing: .zero) {
                            if let description = ngo.description {
                                Text("Sobre:")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text(description)
                                    .padding(.top)
                            }
                        }

                        Spacer()
                        
                        Button("Apoiar esta ONG") {
                            if let pixKey = ngo.pixKey, let location = ngo.location {
                                navigator.present(sheet: .donate(pixKey: pixKey, merchantName: ngo.name, merchantCity: location))
                                return
                            }
                            toast("A ONG ainda não cadastrou a Chave Pix!", .error)
                        }
                        .disabled(!isEnabled)
                        .buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled))
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden()
            .toolbarItem(icon: .back, placement: .topBarLeading, action: {
                navigator.dismiss()
            })
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(edges: .top)
        }
    }
}
