//
//  ManagerHTML.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 15/1/24.
//

import Foundation

actor ManagerHTML {
    
    func generateHTMLCode(code: String, keyWords: [String: String]) async -> String {
        var lines: [String] = await getLinesWithLinebreak(text: code)
        lines = await replaceSpaces(lines: lines)
        lines = await addLineBreak(lines: lines)
        lines = await replaceKeywords(lines: lines, keyWords: keyWords)
        
        let joined: String = lines.joined(separator: "\n")
        return joined
    }
    
    private func getLinesWithLinebreak(text: String) async -> [String] {
        text.components(separatedBy: "\n")
    }
    
    private func replaceSpaces(lines: [String]) async -> [String] {
        lines.map { $0.replacingOccurrences(of: " ", with: "&nbsp;") }
    }
    
    private func addLineBreak(lines: [String]) async -> [String] {
        lines.map { $0 + "<br>" }
    }
    
    private func replaceKeywords(lines: [String], keyWords: [String: String]) async -> [String] {
        lines.map { line in
            replaceKeywords(line: line, keyWords: keyWords)
        }
    }
    
    private func replaceKeywords(line: String, keyWords: [String: String]) -> String {
        var line = line
        for (keyword, replacement) in keyWords {
            line = line.replacingOccurrences(of: keyword, with: replacement)
        }
        return line
    }
}
