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

  var plugins: [Plugin] = []

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

    plugins.append(plugin)
  }

}
