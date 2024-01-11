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
    
    var fileManager: ManagerFiles
    let keyWords: [String: String]
    
    init() {
        self.code = ""
        self.fileManager = ManagerFiles()
        self.keyWords = [
            "struct&nbsp;": "<span class='class-key'>struct</span>&nbsp;",
            "var&nbsp;": "<span class='class-key'>var</span>&nbsp;",
            "some&nbsp;": "<span class='class-key'>some</span>&nbsp;",
            "View&nbsp;": "<span class='data-type-key'>View</span>&nbsp;",
            "Text": "<span class='data-type-key'>Text</span>"
        ]
    }
    
    init(code: String, fileManager: ManagerFiles, keyWords: [String: String]) {
        self.code = code
        self.fileManager = fileManager
        self.keyWords = keyWords
    }
    
    func createFile() async {
        do {
            try await fileManager.createFile()
        } catch(let error) {
            print(error)
        }
    }
    
    func generateHTMLCode() {
        var lines: [String] = getLines()
        lines = replaceSpaces(lines: lines)
        lines = addLineBreak(lines: lines)
        lines = replaceKeywords(lines: lines)
        printLines(lines: lines)
    }
    
    private func replaceKeywords(lines: [String]) -> [String] {
        lines.map { line in
            replaceKeywords(line: line)
        }
    }
    
    private func replaceKeywords(line: String) -> String {
        var line = line
        for (keyword, replacement) in keyWords {
            line = line.replacingOccurrences(of: keyword, with: replacement)
        }
        return line
    }
    
    private func getStringInLineText(line: String) -> String? {
        if let firstDoubleQuote = line.firstIndex(of: "\""), let lastDoubleQuote = line.lastIndex(of: "\""), firstDoubleQuote != lastDoubleQuote {
            let range = (line.index(after: firstDoubleQuote)..<lastDoubleQuote)
            return String(line[range])
        }
        return nil
    }
    
    private func addLineBreak(lines: [String]) -> [String] {
        lines.map { $0 + "<br>" }
    }
    
    private func replaceSpaces(lines: [String]) -> [String] {
        lines.map { $0.replacingOccurrences(of: " ", with: "&nbsp;") }
    }
    
    private func getLines() -> [String] {
        code.components(separatedBy: "\n")
    }
    
    private func printLines(lines: [String]) {
        for line in lines {
            print(line)
        }
    }
}
