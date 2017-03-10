import Foundation

enum PluginError: Error {
  case failedToLoad
  case typeCastingFailed(String)
  case conformFailed
}

struct PluginContainer {
  let path: String
  var plugin: Plugin
  var bundle: Bundle
}

class PluginLoader {

  var plugins: [PluginContainer] = []

  func loadPlugins(fileLoader: FileLoader, _ completion: (() -> Void)? = nil) throws {
    do {
      let plugins = try fileLoader.contents()

      for plugin in plugins {
        do {
          try load(plugin: plugin, at: .documents)
        } catch let error as PluginError  {
          throw error
        }
      }
    }

    completion?()
  }

  func load(plugin: String, at path: Path) throws {
    let pluginPath = path.rawValue
      .appending("/")
      .appending(plugin)

    guard let bundle = Bundle.init(path: pluginPath), bundle.load() else {
      throw PluginError.failedToLoad
    }

    guard let pluginClass = bundle.principalClass as? NSObject.Type else {
      throw PluginError.typeCastingFailed("Plugin principal class does not inherit from NSObject")
    }

    guard let plugin = pluginClass.init() as? Plugin else {
      throw PluginError.conformFailed
    }

    let container = PluginContainer(path: pluginPath,
                                          plugin: plugin,
                                          bundle: bundle)
    plugins.append(container)
  }
}
