import LIBC
import SwiftOpenGL.gl
import Foundation

class Texture {
    var filePath: String
    var width: Int32(0)
    var height: Int32(0)
    var channel: Int32(0)
    var texture: UInt32(0)

    init(filePath: String) {
        self.filePath = filePath
    }

    func load() {
        let data = stbi_load(self.filePath,
            &self.width, &self.height, &self.channel, 0)
        if data != nil {

        }
        stbi_image_free(data)
    }
}