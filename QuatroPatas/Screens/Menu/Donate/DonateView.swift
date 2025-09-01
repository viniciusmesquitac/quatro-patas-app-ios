//
//  DonateView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/09/25.
//

import SwiftUI
import WebKit

struct DonateView: View {

    @State var url: URL = URL(string: "https://apoia.se/quatropatasfortaleza")!
    @State private var webPage = WebPage()
    @EnvironmentObject var navigator: Navigator
    
    var body: some View {
        content
            .onAppear {
                let request = URLRequest(url: url)
                webPage.load(request)
            }
            .onDisappear {
                webPage.stopLoading()
            }
            .toolbar(.hidden, for: .tabBar)
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden(true)
            .toolbarItem(icon: .back, placement: .topBarLeading) {
                navigator.dismiss()
            }
    }

    private var content: some View {
           ZStack {
               Color.white
               if webPage.isLoading {
                   DotsLoader()
                       .padding()
               } else {
                   WebView(webPage)
               }
           }
       }
}
