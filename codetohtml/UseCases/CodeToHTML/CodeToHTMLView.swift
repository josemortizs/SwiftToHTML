//
//  ContentView.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 10/1/24.
//

import SwiftUI

struct CodeToHTMLView: View {
    
    @State private var viewmodel = CodeToHTMLViewModel()

    var body: some View {
        HStack(alignment: .center) {
            TextEditor(text: $viewmodel.code)
            
            Button {
                Task { await viewmodel.generateHTMLCode() }
            } label: {
                Text("Generar HTML")
            }
        }
        .padding()
        .task { await viewmodel.createFile() }
    }
}

#Preview {
    CodeToHTMLView()
}
