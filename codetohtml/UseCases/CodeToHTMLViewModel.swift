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
    
    init() {
        self.code = ""
        self.fileManager = ManagerFiles()
    }
    
    init(code: String, fileManager: ManagerFiles) {
        self.code = code
        self.fileManager = fileManager
    }
    
    func createFile() async {
        do {
            try await fileManager.createFile()
        } catch(let error) {
            print(error)
        }
    }
}
