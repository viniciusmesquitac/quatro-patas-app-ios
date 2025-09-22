//
//  AgePickerView.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 07/09/25.
//

import SwiftUI

struct AgePickerView: View {
    @Binding var years: Int
    @Binding var months: Int
    
    @State private var showPicker = false
    
    var isEmpty: Bool {
        years == 0 && months == 0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    showPicker.toggle()
                }
            }) {
                HStack {
                    Text("\(years) anos, \(months) meses")
                    Spacer()
                    SFIcon.image(.arrow_down, color: isEmpty ? .secondary : .primary)
                        .rotationEffect(.degrees(showPicker ? 180 : 0))
                }
                .foregroundStyle(isEmpty ? .secondary : .primary)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(isEmpty ? Color.gray.opacity(0.2) : Color.primaryColor.opacity(0.2))
                .cornerRadius(CornerRadius.medium.rawValue)
            }
            .buttonStyle(NoneButtonStyle())
            
            if showPicker {
                VStack(spacing: .zero) {
                    HStack(spacing: .zero) {
                        VStack {
                            Spacer()
                            Text("Anos")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker(String(), selection: $years) {
                                ForEach(0...31, id: \.self) { year in
                                    Text("\(year)").tag(year)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .clipped()
                            .onChange(of: years) {
                                withAnimation {
                                    showPicker = false
                                }
                            }
                        }
                        
                        VStack {
                            Text("Meses")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker(String(), selection: $months) {
                                ForEach(0...12, id: \.self) { month in
                                    Text("\(month)").tag(month)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .clipped()
                            .onChange(of: months) {
                                withAnimation {
                                    showPicker = false
                                }
                            }
                        }
                    }
                    .padding(Padding.medium.rawValue)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(CornerRadius.medium.rawValue)
                }
            }
        }
    }
}
