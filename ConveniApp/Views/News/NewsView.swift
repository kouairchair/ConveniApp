//
//  NewsView.swift
//  NewsView
//
//  Created by tanakabp on 2021/08/19.
//

import SwiftUI

struct NewsView: View {
    var appleNews: AppleNews
    
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none
    let minTrailingOffset: CGFloat = -60
    
    enum VisibleButton {
        case none, left, right
    }
    
    func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                if let url = URL(string: appleNews.href) {
                    Link(appleNews.title, destination: url)
                        .foregroundStyle(.yellow, .white)
                } else {
                    Text(appleNews.title)
                        .foregroundStyle(.yellow, .white)
                }
                
                HStack(spacing: 10) {
                    if let authorImage = appleNews.authorImage {
                        Image(uiImage: authorImage)
                            .symbolVariant(.fill)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow, .white)
                    }
                    
                    Text(appleNews.authorName)
                        .font(.system(size: 15))
                        .foregroundStyle(.white)
                    
                    Text(appleNews.postedTime)
                        .font(.system(size: 15))
                        .foregroundStyle(.white)
                }
            }
            .contentShape(Rectangle())
            .offset(x: offset)
            .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .local)
                    .onChanged({ (value) in
                        let totalSlide = value.translation.width + oldOffset
                        if (Int(minTrailingOffset * 2)...0 ~= Int(totalSlide)) {
                            withAnimation {
                                offset = totalSlide
                                print("offset:\(offset)")
                            }
                        }
                        ///can update this logic to set single button action with filled single button background if scrolled more then buttons width
                    })
                     // https://prafullkumar77.medium.com/swiftui-how-to-make-custom-swipe-able-cell-727a27abdddd
                    .onEnded({ value in
                        withAnimation {
    //                        if visibleButton == .left && value.translation.width < -20 { ///user dismisses left buttons
    //                            reset()
    //                        } else if  visibleButton == .right && value.translation.width > 20 { ///user dismisses right buttons
    //                            reset()
    //                        } else if offset > 25 || offset < -25 { ///scroller more then 50% show button
    //                            if offset > 0 {
    //                                visibleButton = .left
    //                                offset = maxLeadingOffset
    //                            } else {
    //                                visibleButton = .right
    //                                offset = minTrailingOffset
    //                            }
    //                            oldOffset = offset
    //                            ///Bonus Handling -> set action if user swipe more then x px
    //                        } else {
    //                            reset()
    //                        }
                        }
                    }))
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            reset()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
                            print("")
                        }
                    }, label: {
                        ArchiveButtonView.init(cellHeight: proxy.size.height)
                    })
                }.offset(x: (-1 * minTrailingOffset) + offset + Constants.archiveButtonWidth)
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
