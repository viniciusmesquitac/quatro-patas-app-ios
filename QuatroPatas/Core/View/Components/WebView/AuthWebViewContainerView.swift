//
//  AuthWebViewContainerView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/10/25.
//

import SwiftUI


struct AuthWebViewContainerView: View {
    
    let request: URLRequest
    @State var onCompletion: ((URL) -> Void)? = nil
    
    @State var isLoading: Bool = true
    
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        ZStack {
            AuthWebView(request: request, onCompletion: $onCompletion, isLoading: $isLoading)
                .ignoresSafeArea(edges: .all)
        }
        .overlay {
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            }
        }
        .toolbarItem(icon: .close, placement: .topBarTrailing) {
            navigator.dismiss()
        }
        
    }
}
