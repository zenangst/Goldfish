import Cocoa

let fileLoader = FileLoader { try? $0.createPluginDirectoryIfNeeded() }
let pluginLoader = PluginLoader()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  static let windowStyleMask: NSWindowStyleMask = [.titled, .resizable]
  var window: NSWindow?
  var tabs: [NSWindow] = []
  var directoryWather: DirectoryWatcher?

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
    directoryWather = DirectoryWatcher(path: .documents, pluginsDidChange)

    for container in pluginLoader.pluginContainers {
      let window = NSWindow(contentRect: NSRect.zero,
                            styleMask: AppDelegate.windowStyleMask,
                            backing: .retained, defer: false)
      container.plugin.pluginDidLoad()
      window.title = container.plugin.name
      window.contentViewController = container.plugin.controller
      let size = CGSize(width: 640, height: 320)
      window.minSize = size
      window.setFrame(NSRect(origin: CGPoint.zero, size: size), display: false)

      if self.window == nil {
        self.window = window
        window.center()
        window.makeKeyAndOrderFront(nil)
      }

      self.window?.addTabbedWindow(window, ordered: .below)
      self.tabs.append(window)
    }
  }

  func pluginsDidChange(watcher: DirectoryWatcher) {
//    for container in pluginLoader.pluginContainers {
////      container.plugin.pluginDidLoad()
//    }
  }
}

