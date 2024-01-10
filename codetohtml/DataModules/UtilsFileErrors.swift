//
//  UtilsFileErrors.swift
//  codetohtml
//
//  Created by Jose Manuel Ortiz Sanchez on 10/1/24.
//

import Foundation

enum UtilFilesError: Error {
    case cantGetDocumentDirectory
    case errorCreatingDirectory
    case errorCreatingFile
    case errorWritintFile
    case errorReadingFile
}
