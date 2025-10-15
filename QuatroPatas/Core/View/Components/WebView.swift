//
//  WebView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 09/09/25.
//


import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    
    var request: URLRequest
    
    @Binding var isLoading: Bool
    @Binding var goBack: Bool
    @Binding var canGoBack: Bool
    @Binding var isFormSubmitted: Bool

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var formSession: FormSessionManager
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let disableZoomScript = WKUserScript(source:  """
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        document.getElementsByTagName('head')[0].appendChild(meta);
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let userContentController = WKUserContentController()
        userContentController.addUserScript(disableZoomScript)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.websiteDataStore = WKWebsiteDataStore.default()

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isInspectable = true
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false

        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if goBack {
            let js = """
            const voltar = document.querySelector('[jsname="GeGHKb"]');
            if (voltar) {
                voltar.click();
            } else {
                console.log('Botão Voltar não encontrado.');
            }
            """
            uiView.evaluateJavaScript(js)
        }
    }

    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            let request = navigationAction.request
            
            guard let body = request.httpBody,
                  let bodyString = String(data: body, encoding: .utf8) else {
                decisionHandler(.allow)
                return
            }
            
            parent.formSession.update(from: bodyString)
    
            if navigationAction.navigationType == .formSubmitted {
                if bodyString.contains("back=") {
                    decisionHandler(.cancel)
                    parent.navigator.dismiss()
                    parent.formSession.page -= 1
                    return
                }

                if bodyString.contains("continue=") {
                    decisionHandler(.cancel)
                    var requestWithCachedBody = request
                    requestWithCachedBody.httpBody = parent.formSession.encodedBody(isContinuing: true)
                    parent.navigator.navigate(to: .webView(requestWithCachedBody))
                    parent.formSession.page += 1
                    return
                }

                parent.isFormSubmitted = true
                parent.formSession.page = 0
                
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("""
            document.body.style.webkitUserSelect='none';
            document.body.style.userSelect='none';
            """)
            webView.evaluateJavaScript("""
            document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '120%';
            document.getElementsByTagName('body')[0].style.fontSize = '18px';
            """)
            
            webView.evaluateJavaScript("""
                const loginBanner = document.querySelector('.DqBBlb');
                if (loginBanner) {
                    loginBanner.style.display = 'none';
                }
                """)
            parent.goBack = false
            parent.canGoBack = webView.canGoBack
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.parent.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            parent.isLoading = false
        }
    }
}
