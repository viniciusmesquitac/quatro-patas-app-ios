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
    
    private let supabaseURL = URL(string: "https://lhonxgkncgneeocannli.supabase.co")!
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxob254Z2tuY2duZWVvY2FubmxpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA4NDIzMjQsImV4cCI6MjA3NjQxODMyNH0.i2rASSNKhQ5FDR3H-iluVUTrf_J0GPvWasEMKFstmyw"

    let client: SupabaseClient

    private init() {
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
