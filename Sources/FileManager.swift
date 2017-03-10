import Foundation

enum Path: String {
  case documents

  var rawValue: String {
    switch self {
    case .documents:
      let applicationUrls = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask).last?.path
      guard let applicationUrl = applicationUrls
        else {
          assertionFailure("Could not find application support directory.")
          return ""
      }

      let infoDictionary = Bundle.main.infoDictionary
      guard let bundleExecutable = infoDictionary?["CFBundleExecutable"] as? String
        else
      {
        assertionFailure("Could not find application support directory.")
        return ""
      }

      return applicationUrl.appending("/").appending(bundleExecutable)
    }
  }
}

enum FileLoaderError: Error {
  case noPlugins
  case fileLoaderError(Error)
}

class FileLoader {

  let manager = FileManager.default
  static var defaultQuery: (String) throws -> Bool = { $0.hasSuffix(".bundle") }

  convenience init(_ closure: (FileLoader) -> Void) {
    self.init()
    closure(self)
  }

  func contents(of path: Path = .documents, _ includeElement: (String) throws -> Bool = defaultQuery) throws -> [String] {
    do {
      let contents = try FileManager.default.contentsOfDirectory(atPath: path.rawValue)
      let results = try contents.filter(includeElement)

      if results.isEmpty {
        throw FileLoaderError.noPlugins
      }

      return results
    } catch let error as NSError {
      throw FileLoaderError.fileLoaderError(error)
    }
  }

  func createPluginDirectoryIfNeeded() throws {
    var isDirectory: ObjCBool = false
    manager.fileExists(atPath: Path.documents.rawValue, isDirectory: &isDirectory)

    guard !isDirectory.boolValue else {
      return
    }

    do {
      try manager.createDirectory(atPath: Path.documents.rawValue,
                                      withIntermediateDirectories: false,
                                      attributes: nil)
    } catch let error {
      throw error
    }
  }
}
