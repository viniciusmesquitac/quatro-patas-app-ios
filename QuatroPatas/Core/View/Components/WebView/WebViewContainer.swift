//
//  WebViewContainer.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 09/09/25.
//

import SwiftUI

struct WebViewContainer: View {

    var request: URLRequest
    
    @StateObject private var state = WebViewState()
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var formSession: FormSessionManager
    
    @State var popUp: WebViewPopup? = nil
    
    var body: some View {
        WebView(request: request, state: state, popUp: $popUp)
            .ignoresSafeArea(.container, edges: .all)
        .overlay {
            if state.isLoading {
                LoadingView()
                    .transition(.opacity)
            }
        }
        .animation(.bouncy, value: state.isLoading)
        .navigationBarBackButtonHidden(true)
        .toolbarItem(icon: .back, placement: .topBarLeading, action: {
            guard !state.isFormSubmitted else {
                navigator.popToRoot()
                return
            }
            if formSession.page > 1 {
                state.goBack = true
            } else {
                formSession.responses = [:]
                navigator.dismiss()
            }
        })
        .alert(popUp?.title ?? String(), isPresented: $state.showPopup, actions: {
            ForEach(popUp?.buttons ?? [], id: \.id) { button in
                Button(button.text, role: button.role) {
                    popUp?.didTapButton?(button.text)
                }
            }

        }, message: { Text(popUp?.description ?? String()) })
        .onDisappear {
            formSession.page -= 1
        }
        .toolbar(.hidden, for: .tabBar)
    }
}
