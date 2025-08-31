//
//  Tip+Mock.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 30/08/25.
//


extension Tip {
    static let felv = Tip(
        title: "O que é FeLV?",
        description: [
            TextFragment(content: """
        O vírus da leucemia felina (FeLV) é uma doença viral grave que afeta gatos.
        Ele compromete o sistema imunológico, tornando o animal mais suscetível a outras doenças e podendo levar ao desenvolvimento de câncer.
        
        A transmissão ocorre principalmente pelo contato direto com saliva, secreções nasais, ou por arranhões e mordidas de gatos infectados.
        Gatos que vivem em ambientes com múltiplos felinos têm maior risco de infecção.
        
        Não há cura definitiva, mas a prevenção é possível através da vacinação, testes regulares e evitando contato com gatos infectados.
      """, isBold: false)
        ]
    )

    static let vaccinated = Tip(title:"Vacinação", description: [
        TextFragment(content: "")
    ])

    static let neutered = Tip(title:"Castração", description: [
        TextFragment(content: "")
    ])

    static let adoption = Tip(
        title: "Como funciona?",
        description: [
            TextFragment(content: "passo 1 - preencher formulário", isBold: true),
            TextFragment(content: "O formulário é essencial para que a ONG ou protetor possa te conhecer melhor e encontrar um seu parceiro"),
            
            TextFragment(content: "passo 2 - aprovação da ONG", isBold: true),
            TextFragment(content: "agora a ONG irá avaliar suas respostas e aprovar ou não a sua solicitação, chegará uma notificação com instruções assim que o status mudar"),
            
            TextFragment(content: "passo 3 - combinar adoção", isBold: true),
            TextFragment(content: "agora que você já recebeu todas as instruções, a ONG será responsável por combinar a entrega com você, lembre-se que no ato da entrega você precisará do seu documento com foto para registrar a adoção")
        ]
    )
}
