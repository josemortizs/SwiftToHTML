//
//  UtilFiles.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 10/1/24.
//

import Foundation

actor ManagerFiles {
    
    var directory: String
    var file: String
    
    init() {
        self.directory = "codes"
        self.file = "code.txt"
    }
    
    init(directory: String, file: String) {
        self.directory = directory
        self.file = file
    }
    
    var path: String {
        return "\(directory)/\(file)"
    }
    
    func generateHTML(content: String) async throws {
        try await writeToFile(content: content)
    }
    
    func createFile() async throws {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let codesDirectory = documentsDirectory.appendingPathComponent(self.directory)
            try await createDirectoryIfNoExists(codesDirectory: codesDirectory)
            try await createInitialFile(codesDirectory: codesDirectory)
        } else {
            throw UtilFilesError.cantGetDocumentDirectory
        }
    }
    
    private func writeToFile(content: String) async throws {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = documentsDirectory.appendingPathComponent(self.path)
            
            do {
                try content.write(to: fileURL, atomically: false, encoding: .utf8)
                print("Contenido del archivo actualizado.")
            } catch {
                print("Error al escribir en el archivo: \(error)")
                throw UtilFilesError.errorWritintFile
            }
        } else {
            throw UtilFilesError.cantGetDocumentDirectory
        }
    }
    
    private func createInitialFile(codesDirectory: URL) async throws {
        do {
            let fileURL = codesDirectory.appendingPathComponent(self.file)
            let text = ""
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Archivo creado en: \(fileURL.path)")
        } catch {
            print("Error al crear el archivo: \(error)")
            throw UtilFilesError.errorCreatingFile
        }
    }
    
    private func createDirectoryIfNoExists(codesDirectory: URL) async throws {
        if FileManager.default.fileExists(atPath: codesDirectory.path) == false {
            do {
                try FileManager.default.createDirectory(
                    at: codesDirectory,
                    withIntermediateDirectories: true,
                    attributes: nil)
            } catch {
                throw UtilFilesError.errorCreatingDirectory
            }
        }
    }
}
