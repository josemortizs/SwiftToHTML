//
//  Keyword.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 24/1/24.
//

import Foundation

struct Keyword: Codable {
    let key: String
    let value: String
    let css: String
}

struct KeywordSet: Codable {
    let keyLiterals: Keyword
    let keywords: [Keyword]
}
