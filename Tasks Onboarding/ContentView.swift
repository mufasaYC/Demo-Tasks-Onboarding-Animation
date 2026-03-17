//
//  ContentView.swift
//  Tasks Onboarding
//
//  Created by Mustafa Yusuf on 3/17/26.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace var namespace
    
    @State private var columns: [Column] = []

    @State private var spacing: CGFloat = .zero
    @State private var activeColumn: Column? = nil
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach($columns) { $column in
                ColumnCard(column: $column, activeColumn: $activeColumn, namespace: namespace)
                
                if $column.wrappedValue != columns.last, !column.isExpanded {
                    Rectangle()
                        .foregroundStyle(Color(.separator))
                        .frame(width: 1, height: 2*Spacing.standard)
                }
            }
        }
        .task {
            await startAnimation()
        }
    }
    
    @MainActor
    private func startAnimation() async {
        let columns: [Column] = [
            .init(position: 0, title: "Do", color: .blue),
            .init(position: 1, title: "Doing", color: .orange),
            .init(position: 2, title: "Done", color: .green, isCompleted: true),
        ]
        
        for column in columns {
            withAnimation(.bouncy) {
                self.columns.append(column)
            }
            try! await Task.sleep(for: .milliseconds(500))
        }
        
        for (index, _) in self.columns.enumerated() {
            withAnimation(.spring) {
                self.columns[index].isExpanded = true
                self.spacing = -Spacing.standard
            }
        }
        
        try! await Task.sleep(for: .milliseconds(800))
        
        startAnimatingTheTask()
    }
    
    private func startAnimatingTheTask() {
        defer {
            Task { @MainActor in
                try! await Task.sleep(for: .milliseconds(800))
                self.startAnimatingTheTask()
            }
        }
        guard let activeColumn,
              let index = self.columns.firstIndex(of: activeColumn) else {
            withAnimation(.bouncy) {
                activeColumn = columns.first
            }
            return
        }
        
        if index + 1 < columns.count {
            withAnimation(.bouncy) {
                self.activeColumn = columns[index+1]
            }
        } else {
            withAnimation(.bouncy) {
                self.activeColumn = nil
            }
        }
    }
}

struct ColumnCard: View {
    @Binding var column: Column
    @Binding var activeColumn: Column?
    
    var namespace: Namespace.ID
    
    private var leadingPadding: CGFloat {
        guard column.isExpanded else {
            return .zero
        }
        let multiplier: CGFloat = column.position.isEven ? -1 : 1
        return multiplier * 2 * Spacing.standard
    }
    
    private var rotationInDegrees: CGFloat {
        guard column.isExpanded else {
            return .zero
        }
        return column.position.isEven ? -5 : 5
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.standard) {
            HStack(spacing: Spacing.standard) {
                if !column.isExpanded {
                    Checkbox(column: $column)
                }
                Text(column.title)
                    .font(.headline)
            }
            .padding(.vertical, Spacing.medium)
            .padding(.horizontal, Spacing.standard)
            .background {
                FillBorderedShape(
                    shape: .rect(cornerRadius: 16),
                    fillColor: Color(.systemBackground),
                    borderColor: Color(.separator)
                )
            }
            
            if column.isExpanded {
                
                TaskView(column: $column, activeColumn: $activeColumn)
                    .matchedGeometryEffect(id: "task", in: namespace)
                
                Text("This is a redacted task")
                    .redacted(reason: .placeholder)
            }
        }
        .padding(column.isExpanded ? Spacing.standard : .zero)
        .background {
            if column.isExpanded {
                column.color
                    .clipShape(.rect(cornerRadius: 16))
            }
        }
        .rotationEffect(.degrees(rotationInDegrees))
        .padding(.leading, leadingPadding)
    }
}

#Preview {
    ContentView()
}
