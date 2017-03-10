import Cocoa

let fileLoader = FileLoader { try? $0.createPluginDirectoryIfNeeded() }
let pluginLoader = PluginLoader()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    do {
      try pluginLoader.loadPlugins(fileLoader: fileLoader) { [weak self] in
        self?.didFinishLoadingPlugins()
      }
    } catch let error as NSError {
      print("Error: \(error)")
    } catch let error as PluginError {
      handlePluginError(error)
    }
  }

  func handlePluginError(_ error: PluginError) {
    switch error {
    case .failedToLoad:
      print("Failed to load plugin.")
    case .typeCastingFailed(let string):
      print(string)
    case .conformFailed:
      print("Plugin does not conform to protocol")
    }
  }

  func didFinishLoadingPlugins() {
    print("Tada!")
  }
}

