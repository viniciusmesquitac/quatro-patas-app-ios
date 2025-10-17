//
//  SupabaseManager.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 17/10/25.
//


import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    
    // substitua pelas suas credenciais
    private let supabaseURL = URL(string: "")!
    private let supabaseKey = ""

    let client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
