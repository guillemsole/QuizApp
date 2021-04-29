//
//  RoundedButton.swift
//  QuizApp
//
//  Created by Guillem Solé Cubilo on 29/4/21.
//

import SwiftUI

struct RoundedButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(title: String, isEnabled: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action, label: {
            HStack {
                Spacer()
                Text(title)
                    .padding()
                    .foregroundColor(Color.white)
                Spacer()
            }
            .background(Color.blue)
            .cornerRadius(25)
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        
        RoundedButton(title: "Enabled", isEnabled: true) {
            
        }
        .previewLayout(.sizeThatFits)
    
        RoundedButton(title: "Enabled", isEnabled: false) {
            
        }
        .previewLayout(.sizeThatFits)
    }
}
