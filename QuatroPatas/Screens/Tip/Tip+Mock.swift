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
            TextFragment(content: "O vírus da leucemia felina (FeLV) é uma doença viral grave que afeta gatos. Ele compromete o sistema imunológico, tornando o animal mais suscetível a outras doenças e podendo levar ao desenvolvimento de câncer."),
            TextFragment(content: "A transmissão ocorre principalmente pelo contato direto com saliva, secreções nasais, ou por arranhões e mordidas de gatos infectados. Gatos que vivem em ambientes com múltiplos felinos têm maior risco de infecção."),
            TextFragment(content: "Não há cura definitiva, mas a prevenção é possível através da vacinação, testes regulares e evitando contato com gatos infectados.")
        ]
    )

    static let vaccinated = Tip(title: "Vacinação", description: [
        TextFragment(content: "Indica que o animal já recebeu as vacinas recomendadas para sua idade, ajudando a protegê-lo contra doenças comuns e garantindo mais saúde e segurança para ele e para sua futura família.")
    ])

    static let neutered = Tip(title: "Castração", description: [
        TextFragment(content: "Mostra que o animal já foi castrado, o que ajuda no controle populacional, previne problemas de saúde e pode contribuir para um comportamento mais equilibrado.")
    ])

    static let dewormed = Tip(title: "Vermifugado", description: [
        TextFragment(content: "Significa que o animal recebeu vermífugo, prevenindo e combatendo vermes intestinais que podem afetar a saúde e o bem-estar dele.")
    ])
    
    static let fiv = Tip(title: "O que é FIV?", description: [
        TextFragment(content: "A FIV é a sigla em inglês para \"Feline Immunodeficiency Virus\", que se traduz como Vírus da Imunodeficiência Felina. também conhecida como 'Aids felina', é uma doença viral que afeta apenas gatos e não é transmissível para humanos. Ela compromete o sistema imunológico do animal, tornando-o mais vulnerável a infecções."),
        TextFragment(content: "Gatos com FIV podem ter uma boa qualidade de vida com cuidados adequados, alimentação equilibrada e acompanhamento veterinário regular.")
    ])


    static let adoption = Tip(
        title: "Como funciona?",
        description: [
            TextFragment(content: "passo 1 - preencher formulário", isBold: true),
            TextFragment(content: "O formulário é essencial para que a ONG ou protetor possa te conhecer melhor e encontrar um seu parceiro"),
            
            TextFragment(content: "passo 2 - aprovação da ONG", isBold: true),
            TextFragment(content: "agora a ONG irá avaliar suas respostas e aprovar ou não a sua solicitação, enviaremos uma mensagem para confirmar o processo"),
            TextFragment(content: "passo 3 - combinar adoção", isBold: true),
            TextFragment(content: "agora que você já recebeu todas as instruções, a ONG será responsável por combinar a entrega com você, lembre-se que no ato da entrega você precisará do seu documento com foto para registrar a adoção")
        ]
    )
}
