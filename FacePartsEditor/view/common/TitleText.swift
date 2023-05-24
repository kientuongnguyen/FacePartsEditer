//
//  TitleText.swift
//  FacePartsEditor
//
//  Created by Nguyễn Kiến Tường on 23/04/2023.
//

import SwiftUI

public struct TitleFont {
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    let color: Color
}

public let PageTitleFont = TitleFont(fontSize: 30, fontWeight: .bold, color: .black)
public let Header1Font = TitleFont(fontSize: 25, fontWeight: .bold, color: .black)
public let Header2Font = TitleFont(fontSize: 20, fontWeight: .bold, color: .black)
public let Header3Font = TitleFont(fontSize: 15, fontWeight: .bold, color: .black)

let HintFont = TitleFont(fontSize: 13, fontWeight: .regular, color: .gray)
let ParagraphFont = TitleFont(fontSize: 13, fontWeight: .bold, color: .black)

struct TitleText: View {
    let text: String
    let font: TitleFont
    
    var body: some View {
        Text(text)
            .font(.system(size: font.fontSize, weight: font.fontWeight, design: .default))
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TitleText(text: "Sample Title", font: PageTitleFont)

            TitleText(text: "Sample Header 1", font: Header1Font)

            TitleText(text: "Sample Title", font: PageTitleFont)

            TitleText(text: "Sample Title", font: PageTitleFont)
        }
    }
}
