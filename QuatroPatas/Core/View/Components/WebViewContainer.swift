//
//  WebViewContainer.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 09/09/25.
//

import SwiftUI

struct WebViewContainer: View {
    @State private var isLoading = true
    var url: URL
    
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack {
            WebView(url, isLoading: $isLoading)
            
            if isLoading {
                LoadingDotsView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            navigator.dismiss()
        })
        .toolbar(.hidden, for: .tabBar)
    }
}
