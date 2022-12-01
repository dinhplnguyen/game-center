//
//  ProgressBar.swift
//  quiz_app
//
//  Created by Joshua Martinez on 2022-11-25.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(maxWidth: 350, maxHeight: 4)
                .foregroundColor(.gray)
            Rectangle()
                .frame(width: progress, height: 4)
                .foregroundColor(.blue)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 10)
    }
}
