//
//  WebViewState.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 18/10/25.
//

import SwiftUI

final class WebViewState: ObservableObject {
    @Published var isLoading = false
    @Published var canGoBack = false
    @Published var goBack = false
    @Published var isFormSubmitted = false
    @Published var showPopup = false
}
