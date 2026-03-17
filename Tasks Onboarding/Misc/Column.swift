//
//  Column.swift
//  TasksOnboarding
//
//  Created by Mustafa Yusuf on 3/17/26.
//

import SwiftUI

struct Column: Identifiable, Hashable {
    var id: UUID = .init()
    let position: Int
    let title: String
    let color: Color
    let textColor: Color = .white
    var isExpanded: Bool = false
    var isCompleted: Bool = false
}
