//
//  CustomStepper.swift
//  Makanan
//
//  Created by Eliza Vornia on 08/05/25.
//
import SwiftUI

struct CustomStepper: View {
    @Binding var value: Int
    var range: ClosedRange<Int> = 0...30
    
    private var textValue: String {
        String(value)
    }

    var body: some View {
        HStack(spacing: 8) {
            // Tombol minus hanya muncul ketika value > 0
            if value > 0 {
                Button(action: {
                    if value > range.lowerBound {
                        value -= 1
                    }
                }) {
                    Image(systemName: "minus.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                // Text quantity hanya muncul ketika value > 0
                Text(textValue)
                    .frame(width: 25, height: 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if value < range.upperBound {
                    value += 1
                }
            }) {
                Image(systemName: "plus.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var quantity = 0 
        var body: some View {
            VStack {
                CustomStepper(value: $quantity)
                    .padding()
                
                Text("Quantity: \(quantity)")
            }
        }
    }

    return PreviewWrapper()
}
