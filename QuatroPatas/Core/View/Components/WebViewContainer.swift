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
    
    var body: some View {
        ZStack {
            WebView(url, isLoading: $isLoading)
            
            if isLoading {
                DotsLoader()
            }
        }
    }
}
