//
//  UtilFiles.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 10/1/24.
//

import Foundation
import AppKit

actor ManagerFiles {
    
    var directory: String
    var file: String
    var htmlFile: String
    
    init() {
        self.directory = "codes"
        self.file = "code.txt"
        self.htmlFile = "swiftToHTML.txt"
    }
    
    init(
        directory: String,
        file: String,
        htmlFile: String
    ) {
        self.directory = directory
        self.file = file
        self.htmlFile = htmlFile
    }
    
    var path: String {
        return "\(directory)/\(file)"
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
    
    func readFile() async throws -> String {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = documentsDirectory.appendingPathComponent(self.path)
            
            do {
                let content = try String(contentsOf: fileURL, encoding: .utf8)
                return content
            } catch {
                print("Error al leer el archivo: \(error)")
                throw UtilFilesError.errorReadingFile
            }
        } else {
            throw UtilFilesError.cantGetDocumentDirectory
        }
    }
    
    func writeFile(content: [String]) async throws {
        let joined: String = content.joined(separator: "\n")
        try await writeFile(content: joined)
    }
    
    func writeFile(content: String) async throws {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = documentsDirectory.appendingPathComponent(self.path)
            
            do {
                try content.write(to: fileURL, atomically: false, encoding: .utf8)
                print("Contenido del archivo actualizado.")
                showInFinder()
            } catch {
                print("Error al escribir en el archivo: \(error)")
                throw UtilFilesError.errorWritintFile
            }
        } else {
            throw UtilFilesError.cantGetDocumentDirectory
        }
    }
    
    func showInFinder() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            showInFinder(url: documentsDirectory.appendingPathComponent(self.path))
        }
    }
    
    func showInFinder(url: URL?) {
        guard let url = url else { return }
        
        if url.isDirectory {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([url])
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
