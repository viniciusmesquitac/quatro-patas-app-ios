//
//  PixBRCode.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/02/26.
//


import Foundation

enum PixBRCode {
    
    static func generatePayload(
        pixKey: String,
        merchantName: String,
        merchantCity: String,
        amount: Decimal,
        txid: String = "***"
    ) -> String {
        
        func format(_ id: String, _ value: String) -> String {
            let len = String(format: "%02d", value.count)
            return "\(id)\(len)\(value)"
        }
        
        // 00: Payload Format Indicator
        let payloadFormat = format("00", "01")
        
        // 26: Merchant Account Information (GUI + chave)
        let gui = format("00", "br.gov.bcb.pix")
        let key = format("01", pixKey)
        let merchantAccountInfo = format("26", gui + key)
        
        // 52: Merchant Category Code
        let merchantCategoryCode = format("52", "0000")
        
        // 53: Transaction Currency (986 = BRL)
        let currency = format("53", "986")
        
        // 54: Transaction Amount (com 2 casas)
        let amountStr = NSDecimalNumber(decimal: amount).stringValue
        let normalizedAmount = normalizeAmount(amountStr)
        let transactionAmount = format("54", normalizedAmount)
        
        // 58: Country Code
        let countryCode = format("58", "BR")
        
        // 59: Merchant Name (máx 25)
        let name = format("59", String(merchantName.prefix(25)))
        
        // 60: Merchant City (máx 15)
        let city = format("60", String(merchantCity.prefix(15)))
        
        // 62: Additional Data Field Template (TXID)
        let txidField = format("05", String(txid.prefix(25)))
        let additionalData = format("62", txidField)
        
        // 63: CRC (placeholder)
        let crcPlaceholder = "6304"
        
        let partial = payloadFormat
        + merchantAccountInfo
        + merchantCategoryCode
        + currency
        + transactionAmount
        + countryCode
        + name
        + city
        + additionalData
        + crcPlaceholder
        
        let crc = crc16CCITT(partial)
        return partial + crc
    }
    
    private static func normalizeAmount(_ s: String) -> String {
        // garante 2 casas: "1" -> "1.00", "1.5" -> "1.50"
        if s.contains(".") {
            let parts = s.split(separator: ".", omittingEmptySubsequences: false)
            let intPart = parts.first ?? "0"
            let decPart = parts.count > 1 ? parts[1] : "0"
            let padded = String(decPart).padding(toLength: 2, withPad: "0", startingAt: 0)
            return "\(intPart).\(padded.prefix(2))"
        } else {
            return "\(s).00"
        }
    }
    
    /// CRC16-CCITT (0x1021), init 0xFFFF, output uppercase hex 4 chars
    private static func crc16CCITT(_ input: String) -> String {
        let bytes = Array(input.utf8)
        var crc: UInt16 = 0xFFFF
        let poly: UInt16 = 0x1021
        
        for b in bytes {
            crc ^= UInt16(b) << 8
            for _ in 0..<8 {
                if (crc & 0x8000) != 0 {
                    crc = (crc << 1) ^ poly
                } else {
                    crc <<= 1
                }
            }
        }
        
        return String(format: "%04X", crc & 0xFFFF)
    }
}