import Foundation

class ProjectPlugin: NSObject, Plugin {

  var name: String = "Projects"
  var version = "0.0.1"
  var controller: NSViewController?

  @objc func pluginDidLoad() {
    controller = ProjectController()
    controller?.title = name
  }
}
