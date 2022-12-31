//
//  RoundTextButton.swift
//  Vlog
//
//  Created by Christopher James on 25/09/2022.
//

import SwiftUI

struct RoundTextButton: View {
    var text: String
    var color: Color
    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(LocalizedStringKey(stringLiteral: text))
            .frame(height: 15.0)
            .foregroundColor(Color.white)
            .padding(EdgeInsets(top: 6.0, leading: 16.0, bottom: 6.0, trailing: 16.0))
            .background(color)
            .cornerRadius(40)
            .overlay(RoundedRectangle(cornerRadius: 40)
                    .stroke(color, lineWidth: 4))
    }
}
