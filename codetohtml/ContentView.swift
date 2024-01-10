//
//  ContentView.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 10/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var code: String
    
    var fileManager: ManagerFiles
    
    init() {
        self._code = State(initialValue: "")
        self.fileManager = ManagerFiles()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            TextEditor(text: $code)
            
            Button {
                Task {
                    try await fileManager.generateHTML(content: code)
                }
            } label: {
                Text("Generar HTML")
            }
        }
        .padding()
        .task { await createFile() }
    }
    
    private func createFile() async {
        do {
            try await fileManager.createFile()
        } catch(let error) {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}

enum UtilFilesError: Error {
    case cantGetDocumentDirectory
    case errorCreatingDirectory
    case errorCreatingFile
    case errorWritintFile
}
