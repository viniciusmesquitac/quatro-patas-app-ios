//
//  AuthWebView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 16/10/25.
//

import SwiftUI
import WebKit

struct AuthWebView: UIViewRepresentable {
    let request: URLRequest
    @Binding var onCompletion: ((URL) -> Void)?
    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, onCompletion: onCompletion)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.isInspectable = true
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: AuthWebView
        var onCompletion: ((URL) -> Void)?

        init(parent: AuthWebView, onCompletion: ((URL) -> Void)?) {
            self.parent = parent
            self.onCompletion = onCompletion
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            

            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }

            if url.absoluteString.contains("LoginDone") || url.absoluteString.contains("flowName=GlifWebSignIn&passive=true") {
                onCompletion?(url)
                decisionHandler(.cancel)
                return
            }

            if navigationAction.navigationType == .linkActivated  {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            
            webView.evaluateJavaScript("""
            (function() {
                const css = `
                    header {
                        display: none !important;
                        visibility: hidden !important;
                        height: 0 !important;
                        overflow: hidden !important;
                    }
                `;
                const style = document.createElement('style');
                style.textContent = css;
                document.head.appendChild(style);
                console.log('✅ Header escondido.');
            })();
            """)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.parent.isLoading = false
            })

        }
    }
}
