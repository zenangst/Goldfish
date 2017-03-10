import Cocoa

class ProjectController: NSViewController {

  override func loadView() {
    view = NSView()
    view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
    view.autoresizesSubviews = true
  }
}
