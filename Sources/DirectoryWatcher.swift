import Foundation

class DirectoryWatcher {

  let fileQueue: DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
  let path: Path
  let closure: (DirectoryWatcher) -> Void

  var source: DispatchSourceFileSystemObject?

  init(path: Path, _ closure: @escaping (DirectoryWatcher) -> Void) {
    self.path = path
    self.closure = closure
  }

  func start() {
    let eventMask: DispatchSource.FileSystemEvent = [.delete, .write, .extend, .attrib, .link, .rename, .revoke]
    source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: Int32(open(self.path.rawValue, O_EVTONLY)),
                                                       eventMask: eventMask,
                                                       queue: fileQueue)

    source?.setEventHandler(handler: { [weak self] in
      guard let strongSelf = self else {
        return
      }
      strongSelf.source?.cancel()
      strongSelf.source = nil

      DispatchQueue.main.async {
        strongSelf.closure(strongSelf)
      }
    })

    source?.resume()
  }
}
