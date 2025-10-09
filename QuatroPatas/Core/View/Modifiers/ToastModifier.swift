//
//  ToastModifier.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 28/08/25.
//

import SwiftUI

struct ToastItem: Identifiable, Hashable {
    let id = UUID()
    var message: String
    var type: ToastType
}

enum ToastType {
    case success
    case error
    case warning
}

struct ToastModifier: ViewModifier {
    
    @State private var toast: ToastItem?
    
    func body(content: Content) -> some View {
        content
            .environment(\.toast, ToastAction(action: { message, type in
                withAnimation {
                    self.toast = .init(message: message, type: type)
                }
            }))
            .overlay(alignment: .bottom) {
                if toast != nil {
                    VStack {
                        ToastView(toast: $toast)
                            .padding(.bottom, 64)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
    }
}

extension View {
    func toast() -> some View {
        modifier(ToastModifier())
    }
}
