import Cocoa

let fileLoader = FileLoader { try? $0.createPluginDirectoryIfNeeded() }
let pluginLoader = PluginLoader()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

  static let windowStyleMask: NSWindowStyleMask = [.titled, .resizable, .closable]
  var windowController: NSWindowController = NSWindowController()
  var directoryWather: DirectoryWatcher?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    windowController.windowFrameAutosaveName = "GoldFish"
    loadPlugins { [weak self] in
      if let window = self?.windowController.window , window.frame.size.width < window.minSize.width {
        let previousRect = window.frame
        window.setFrame(NSRect(
          x: previousRect.origin.x,
          y: previousRect.origin.y,
          width: window.minSize.width,
          height: window.minSize.height
        ), display: false)
      }
    }
  }

  func applicationDidBecomeActive(_ notification: Notification) {
    windowController.window?.becomeMain()
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

  func loadPlugins(_ closure: (() -> Void)? = nil) {
    do {
      try pluginLoader.loadPlugins(fileLoader: fileLoader) { [weak self] in
        guard let strongSelf = self else {
          return
        }

        strongSelf.didFinishLoadingPlugins()
        strongSelf.directoryWather = DirectoryWatcher(path: .documents,
                                                      strongSelf.pluginsDidChange)
        strongSelf.directoryWather?.start()
        closure?()
      }
    } catch let error as NSError {
      print("Error: \(error)")
    } catch let error as PluginError {
      handlePluginError(error)
    }
  }

  func windowDidBecomeKey(_ notification: Notification) {
    guard let window = notification.object as? NSWindow else {
      return
    }

    guard let contentViewController = window.contentViewController else {
      return
    }

    guard let container = pluginLoader.pluginContainers
      .filter({ $0.plugin.controller?.isEqual(contentViewController) == true }).first
      else {
        return
    }

    container.plugin.pluginDidAppear()

//    let container = pluginLoader.pluginContainers
//      .filter({ ($0.plugin.controller?.isEqual(contentViewController))! }).first
//
//    container?.plugin.pluginDidAppear()
  }

  func didFinishLoadingPlugins() {
    for container in pluginLoader.pluginContainers {
      let window = NSWindow(contentRect: NSRect.zero,
                            styleMask: AppDelegate.windowStyleMask,
                            backing: .nonretained , defer: false)
      container.plugin.pluginDidLoad()
      window.title = container.plugin.name
      window.contentViewController = container.plugin.controller
      let size = CGSize(width: 640, height: 320)
      window.minSize = size
      window.setFrame(NSRect(origin: CGPoint.zero, size: size), display: false)
      window.delegate = self

      if windowController.window == nil {
        windowController.window = window
        windowController.window?.makeKeyAndOrderFront(nil)
      } else {
        windowController.window?.addTabbedWindow(window, ordered: .below)
      }
    }
  }

  func restart() {
    let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
    let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
    let task = Process()

    task.launchPath = "/usr/bin/open"
    task.arguments = [path]
    task.launch()
    
    exit(0)
  }

  func pluginsDidChange(watcher: DirectoryWatcher) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.restart()
    }
  }
}

