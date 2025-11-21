//
//  WebViewState.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 18/10/25.
//

import SwiftUI
import WebKit

final class WebViewState: ObservableObject {
    @Published var isLoading = false
    @Published var canGoBack = false
    @Published var goBack = false
    @Published var isFormSubmitted = false
    @Published var showPopup = false
    
    @Published var wkWebView: WKWebView? = nil
}
