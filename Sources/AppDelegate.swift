import Cocoa

let fileLoader = FileLoader { try? $0.createPluginDirectoryIfNeeded() }
let pluginLoader = PluginLoader()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    do {
      let plugins = try fileLoader.contents()

      for plugin in plugins {
        do {
          try pluginLoader.load(plugin: plugin, at: .documents)
        } catch let error as PluginError  {
          switch error {
          case .failedToLoad:
            print("Failed to load plugin.")
          case .typeCastingFailed(let string):
            print(string)
          case .conformFailed:
            print("Plugin does not conform to protocol")
          }
        }
      }
    } catch {
      print("Unable to find any plug-ins.")
    }
  }
}

