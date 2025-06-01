//
//  ContentView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/03/25.
//

import SwiftUI

struct ContentView: View {

    let animals = [
        Animal(
            id: "0",
            name: "Jack",
            age: "1",
            type: "cat",
            description: "kitty",
            status: ""
        ),
        Animal(
            id: "2",
            name: "Lucy",
            age: "1",
            type: "cat",
            description: "kitty",
            status: ""
        ),
        Animal(
            id: "3",
            name: "John",
            age: "1",
            type: "dog",
            description: "doggy",
            status: ""
        )
    ]

    var body: some View {
        VStack {
            List(animals, id: \.id) { item in
                VStack {
                    Text(item.name)
                    Text(item.type)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
