import Foundation
import ObjectiveC

class ProjectPlugin: NSObject, Plugin {

  var name: String = "Project"
  var version = "0.0.1"
  var data: [AnyHashable : Any] = [:]
}
