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

    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var formSession: FormSessionManager
    @Environment(\.toast) var toast

    @ObservedObject var state: WebViewState

    @Binding var popUp: WebViewPopup?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        let disableTextSelectionScript = WKUserScript(source: """
        (function() {
          const style = document.createElement('style');
          style.textContent = `
            * {
              -webkit-user-select: none !important;
              user-select: none !important;
              -webkit-touch-callout: none !important;
            }
          `;
          document.head.appendChild(style);
        })();
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: false)

        let disableZoomScript = WKUserScript(source:  """
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        document.getElementsByTagName('head')[0].appendChild(meta);
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let popupDialogScript = WKUserScript(source:"""
        const observer = new MutationObserver(() => {
          const popups = document.querySelectorAll('[role="alertdialog"]');
          const overlays = document.querySelectorAll('.NBxL9e.iWO5td');

          overlays.forEach(overlay => {
            overlay.style.display = "none";
          });

          popups.forEach(popup => {
            if (popup) {
              popup.style.display = "none";
              const title = popup.querySelector('[role="heading"]')?.innerText || "";
              const description = popup.querySelector('[jsname="bN97Pc"]')?.innerText
                || popup.querySelector('[aria-describedby]')?.innerText
                || "";

              const buttons = Array.from(
                popup.querySelectorAll('[role="button"], [role="presentation"]')
              )
                .map(b => b.innerText.trim())
                .filter((text, i, arr) => text && arr.indexOf(text) === i);
        
              const payload = { title, description, buttons };
              window.webkit.messageHandlers.formPopupDetected.postMessage(payload);
            }
          });
        });
        observer.observe(document.body, { childList: true, subtree: true });
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
    
        let userContentController = WKUserContentController()
        userContentController.addUserScript(popupDialogScript)
        userContentController.addUserScript(disableTextSelectionScript)
        userContentController.addUserScript(disableZoomScript)
        userContentController.add(context.coordinator, name: "formPopupDetected")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.websiteDataStore = WKWebsiteDataStore.default()

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.isInspectable = true
        webView.scrollView.pinchGestureRecognizer?.isEnabled = false

        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if state.goBack {
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

    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
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
                    return
                }
                
                if bodyString.contains("continue=") {
                    decisionHandler(.cancel)
                    var requestWithCachedBody = request
                    requestWithCachedBody.httpBody = parent.formSession.encodedBody(isContinuing: true)
                    parent.navigator.navigate(to: .webView(request))
                    parent.formSession.page += 1
                    return
                }
                
                parent.state.isFormSubmitted = true
                parent.formSession.page = 0
                
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.state.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Altera tamanho do texto
            webView.evaluateJavaScript("""
            document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust = '110%';
            document.getElementsByTagName('body')[0].style.fontSize = '18px';
            """)
    
            // Remove botão rodapé
            webView.evaluateJavaScript("""
            (function() {
              const btn = document.querySelector('button[aria-haspopup="menu"]');
              if (btn) btn.remove();
            })();
            """, completionHandler: nil)
            
            // Altera a fonte
            webView.evaluateJavaScript("""
                const elements = document.querySelectorAll('*');
                elements.forEach(el => {
                    el.style.fontFamily = '-apple-system, sans-serif';
                });
            """)
            
            webView.evaluateJavaScript("""
                const header = document.querySelector('header');
                if (header) header.style.display = 'none';
            """)
            
            parent.state.goBack = false
            parent.state.canGoBack = webView.canGoBack
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.parent.state.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.state.isLoading = false
        }
        
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            // Login no google
            if let url = navigationAction.request.url {
                parent.navigator.present(sheet: .webView(URLRequest(url: url), onResult: { url in
                    self.parent.navigator.dismiss()
                    webView.reload()
                }))
            }
            return nil
        }
    
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let dict = message.body as? NSDictionary,
               let title = dict["title"] as? String,
               let description = dict["description"] as? String,
               let buttons = dict["buttons"] as? [String] {
                
                let popupButton = buttons.map {  PopupButton(text: $0, role: .none) }
                var popUp = WebViewPopup(title: title, description: description, buttons: popupButton)
                popUp.didTapButton = { button in
                    let normalized = button.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    let isClearForm = normalized == "clear form" || normalized == "limpar formulário"

                    let removeAlertDialog = """
                    (function() {
                      const alertDialog = document.querySelector('[role="alertdialog"]');
                      const overlay = document.querySelector('.NBxL9e.iWO5td');

                      if (alertDialog) {
                        const btn = Array
                          .from(alertDialog.querySelectorAll('button, a, [role="button"]'))
                          .find(b => (b.innerText?.trim?.() || b.value?.trim?.()) === "\(button)");

                        if (btn) {
                          btn.click();
                        } else {
                          console.log("⚠️ não achou o botão (alertdialog)");
                        }

                        alertDialog.remove();
                        if (overlay) overlay.remove();
                      }
                    })();
                    """

                    message.webView?.evaluateJavaScript(removeAlertDialog, completionHandler: { _ , _ in
                        if isClearForm {
                            self.parent.navigator.popToRoot()
                            self.parent.toast("Formulário limpo com sucesso!", .success)
                        }
                    })
                }

                parent.popUp = popUp
            }
            
            parent.state.showPopup = true
        }
    }
}
