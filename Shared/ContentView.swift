//
//  ContentView.swift
//  Shared
//
//  Created by Steven Rhey Balan on 6/30/22.
//

import SwiftUI

struct ContentView: View {

    private let defaultHeight: CGFloat = 100

    @State var showCard = false
    @State var bottomState = CGSize.zero
    @State var showFull = false

    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Color(red: 11/255, green: 20/255, blue: 38/255)
                .ignoresSafeArea()

            GeometryReader { geometry in
                let height = geometry.frame(in: .global).height

                ZStack {
                    Rectangle()
                        .fill(Color(red: 34/255, green: 51/255, blue: 85/255))
                        .cornerRadius(12, corners: [.topLeft, .topRight])

                    VStack {
                        Capsule()
                            .fill(.white)
                            .frame(width: 35, height: 3)
                            .padding(.top)

                        Spacer()
                    }
                }
                .offset(y: height - defaultHeight)
                .offset(y: -offset > 0 ? -offset <= (height - defaultHeight) ? offset : -(height - defaultHeight) : 0)
                .gesture(
                    DragGesture()
                        .updating($gestureOffset, body: { value, out, _ in
                            out = value.translation.height
                            onChange()
                        })
                        .onEnded { value in
                            let maxHeight = height - defaultHeight

                            withAnimation {
                                if -offset > defaultHeight && -offset < maxHeight / 2 {
                                    // Mid
                                    offset = -(maxHeight / 2)
                                } else if -offset > maxHeight / 2 {
                                    offset = -maxHeight
                                } else {
                                    offset = 0
                                }
                            }

                            // Storing last offset
                            // So that the gesture can continue from the last position
                            lastOffset = offset
                        }
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }

    func onChange() {
        DispatchQueue.main.async {
            offset = gestureOffset + lastOffset
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
