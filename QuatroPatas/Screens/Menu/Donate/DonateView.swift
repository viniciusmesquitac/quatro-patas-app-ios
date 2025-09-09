//
//  DonateView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 01/09/25.
//

import SwiftUI
import WebKit
//
//struct DonateView: View {
//
//    @State var url: URL = URL(string: "https://apoia.se/quatropatasfortaleza")!
//    @State private var page = WebPage()
//    @EnvironmentObject var navigator: Navigator
//    @Environment(\.toast) var toast
//        
//    var body: some View {
//        content
//            .onAppear {
//                let request = URLRequest(url: url)
//                page.load(request)
//            }
//            .onDisappear {
//                page.stopLoading()
//            }
//            .toolbar(.hidden, for: .tabBar)
//            .edgesIgnoringSafeArea(.all)
//            .navigationBarBackButtonHidden(true)
//            .toolbarItem(icon: .back, placement: .topBarLeading) {
//                navigator.dismiss()
//            }
//    }
//
//    private var content: some View {
//        ZStack {
//            Color.white
//            if page.isLoading {
//                DotsLoader()
//                    .padding()
//            } else {
//                WebView(page)
//                    .onReceive(page.currentNavigationEvent.publisher) { event in
//                        switch event.kind {
//                        case .failed, .failedProvisionalNavigation:
//                            DispatchQueue.main.async {
//                                toast("Falha ao carregar a página", .error)
//                                navigator.dismiss()
//                            }
//                        default:
//                            print(event.kind)
//                        }
//                    }
//            }
//        }
//    }
//
//}
