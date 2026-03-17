//
//  TaskView.swift
//  TasksOnboarding
//
//  Created by Mustafa Yusuf on 3/17/26.
//

import SwiftUI

struct TaskView: View {
    
    @Binding var column: Column
    @Binding var activeColumn: Column?
    
    var body: some View {
        if column == activeColumn {
            HStack(spacing: Spacing.standard) {
                Checkbox(column: $column)
                Text("Buy groceries")
            }
            .padding(Spacing.standard)
            .background(Color(.systemBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
    }
}
