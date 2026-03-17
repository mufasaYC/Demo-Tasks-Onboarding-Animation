//
//  FillBorderedShape.swift
//  TasksOnboarding
//
//  Created by Mustafa Yusuf on 3/17/26.
//

import SwiftUI

struct FillBorderedShape<S: Shape>: View {
    let shape: S
    var fillColor: Color = .clear
    var borderColor: Color = .clear
    var lineWidth: CGFloat = 1

    var body: some View {
        shape
            .fill(fillColor)
            .overlay(
                shape.stroke(borderColor, lineWidth: lineWidth)
            )
    }
}
