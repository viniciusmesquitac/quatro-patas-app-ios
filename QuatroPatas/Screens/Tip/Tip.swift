//
//  Tip.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 29/08/25.
//

struct Tip {
    let title: String
    let descripition: String
    var buttonText: String? = nil
    var buttonAction: (() -> Void)? = nil
}

extension Tip {
    static let felv = Tip(
        title: "O que é FeLV?",
        descripition: """
        O vírus da leucemia felina (FeLV) é uma doença viral grave que afeta gatos.
        Ele compromete o sistema imunológico, tornando o animal mais suscetível a outras doenças e podendo levar ao desenvolvimento de câncer.
        
        A transmissão ocorre principalmente pelo contato direto com saliva, secreções nasais, ou por arranhões e mordidas de gatos infectados.
        Gatos que vivem em ambientes com múltiplos felinos têm maior risco de infecção.
        
        Não há cura definitiva, mas a prevenção é possível através da vacinação, testes regulares e evitando contato com gatos infectados.
      """
    )
}
