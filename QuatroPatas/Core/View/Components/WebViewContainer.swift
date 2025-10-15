//
//  WebViewContainer.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 09/09/25.
//

import SwiftUI

struct WebViewContainer: View {
    @State private var isLoading = false
    @State private var isFormSubmitted = false
    @State private var canGoBack = false
    @State private var goBack = false
    var request: URLRequest
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var formSession: FormSessionManager
    
    
    var body: some View {
        ZStack {
            WebView(request: request, isLoading: $isLoading, goBack: $goBack, canGoBack: $canGoBack, isFormSubmitted: $isFormSubmitted)
                .ignoresSafeArea(edges: .all)
        }
        .overlay {
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            }
        }
        .animation(.bouncy, value: isLoading)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            guard !isFormSubmitted else {
                navigator.popToRoot()
                return
            }
            if formSession.page > 1 {
                goBack = true
            } else {
                formSession.responses = [:]
                navigator.dismiss()
            }
        })
        .toolbar(.hidden, for: .tabBar)
    }
}
