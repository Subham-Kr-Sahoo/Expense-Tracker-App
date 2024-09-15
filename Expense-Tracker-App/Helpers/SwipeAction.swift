//
//  SwipeAction.swift
//  Expense-Tracker-App
//
//  Created by Subham  on 22/06/24.
//

import SwiftUI

struct SwipeAction<Content:View>: View {
    var cornerRadius : CGFloat = 0
    var direction : SwipeDirection = .trailing
    @ViewBuilder var content : Content
    @ActionBuilder var actions:[Action]
    let viewId = UUID()
    @State private var isEnabled : Bool = true
    var body: some View {
        ScrollViewReader{ scrollproxy in
            ScrollView(.horizontal){
                LazyHStack(spacing:0){
                    content
                        .containerRelativeFrame(.horizontal)
                        .background{
                            if let firstAction = actions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                            }
                        }.id(viewId)
                    ActionButtons {
                        withAnimation(.snappy){
                            scrollproxy.scrollTo(viewId , anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background{
                if let lastAction = actions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        }
        .allowsHitTesting(isEnabled)
    }
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count)*100)
            .overlay(alignment: direction.alignment){
                HStack(spacing:0){
                    ForEach(actions){button in
                        Button{
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                button.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                            }
                            
                        }label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                                .buttonStyle(.plain)
                                .background(button.tint)
                        }
                        
                    }
                }
            }
    }
    
    func scrollOffset(_ proxy : GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return direction == .trailing ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
}
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment : Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

struct Action: Identifiable {
    private(set) var id:UUID = .init()
    var tint:Color
    var icon:String
    var iconTint:Color = .white
    var iconFont:Font = .title
    var isEnabled:Bool = true
    var action: ()->()
}

@resultBuilder
struct ActionBuilder{
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}
