//
//  Checkbox.swift
//  TasksOnboarding
//
//  Created by Mustafa Yusuf on 3/17/26.
//

import SwiftUI

struct Checkbox: View {
    
    private let font: UIFont = .preferredFont(forTextStyle: .body)
    @Binding var column: Column
    
    var body: some View {
        RoundedRectangle(cornerRadius: font.lineHeight / 4)
            .fill(column.isCompleted ? column.color : .clear)
            .background {
                RoundedRectangle(cornerRadius: font.lineHeight / 4)
                    .strokeBorder(column.color, lineWidth: 1)
            }
            .frame(width: font.lineHeight, height: font.lineHeight)
            .overlay {
                Image(systemName: "checkmark")
                    .foregroundStyle(column.textColor)
                    .font(.footnote)
            }
    }
}
