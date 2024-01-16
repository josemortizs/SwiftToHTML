//
//  CodeToHTMLViewModel.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 10/1/24.
//

import Foundation
import Combine

final class CodeToHTMLViewModel: ObservableObject {
    
    @Published var code: String
    @Published var html: String = ""
    
    var fileManager: ManagerFiles
    var htmlManager: ManagerHTML
    let keyWords: [String: String]
    
    init() {
        self.code = ""
        self.fileManager = ManagerFiles()
        self.htmlManager = ManagerHTML()
        self.keyWords = [
            "struct&nbsp;": "<span class='class-key'>struct</span>&nbsp;",
            "var&nbsp;": "<span class='class-key'>var</span>&nbsp;",
            "some&nbsp;": "<span class='class-key'>some</span>&nbsp;",
            "View&nbsp;": "<span class='data-type-key'>View</span>&nbsp;",
            "Text": "<span class='data-type-key'>Text</span>"
        ]
    }
    
    init(
        code: String,
        fileManager: ManagerFiles,
        htmlManager: ManagerHTML,
        keyWords: [String: String]
    ) {
        self.code = code
        self.fileManager = fileManager
        self.htmlManager = htmlManager
        self.keyWords = keyWords
    }
    
    func createFile() async {
        do {
            try await fileManager.createFile()
        } catch(let error) {
            print(error)
        }
    }
    
    func generateHTMLCode() async {
        let html = await htmlManager.generateHTMLCode(code: code, keyWords: keyWords)
        self.html = html
        print(html)
        try? await fileManager.writeFile(content: html)
    }
    
    private func getStringInLineText(line: String) -> String? {
        if let firstDoubleQuote = line.firstIndex(of: "\""), let lastDoubleQuote = line.lastIndex(of: "\""), firstDoubleQuote != lastDoubleQuote {
            let range = (line.index(after: firstDoubleQuote)..<lastDoubleQuote)
            return String(line[range])
        }
        return nil
    }
}
