//
//  HappyEndingDetails.swift
//  QuatroPatas
//
//  Created by Vinicius Mesquita Coelho on 21/12/25.
//

import SwiftUI

struct HappyEndingDetails: View {

    let imageUrl: String
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        CachedAsyncImage(url: URL(string: imageUrl))
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity)
            .frame(height: 420)
            .clipShape(RoundedRectangle(cornerRadius: 0))
    }
}
