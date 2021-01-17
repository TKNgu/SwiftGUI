import LIBC
import SwiftOpenGL.gl
import Foundation

class Texture {
    var width = Int32(0)
    var height = Int32(0)
    var channel = Int32(0)
    var texture = UInt32(0)

    init() {
        glad_glGenTextures(1, &self.texture)
        glad_glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)

        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT)
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT)
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)

        glad_glBindTexture(GLenum(GL_TEXTURE_2D), 0)

        var mat: dmat2
    }

    deinit {
        glad_glDeleteTextures(1, &self.texture)
    }

    func load(filePath: String, flip: Bool = true) throws {
        stbi_set_flip_vertically_on_load(flip ? Int32(1) : Int32(0));  
        let data = stbi_load(filePath,
            &self.width, &self.height, &self.channel, 0)
        if data != nil {
            glad_glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
            glad_glTexImage2D(GLenum(GL_TEXTURE_2D), GLint(0), GLint(GL_RGB),
                GLsizei(self.width), GLsizei(self.height),
                GLint(0), GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), data)
            glad_glGenerateMipmap(GLenum(GL_TEXTURE_2D))
            glad_glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        } else {
            throw TextureError.loadfile(log: filePath)
        }
        stbi_image_free(data)
    }

    func bind(id: GLenum) {
        glad_glActiveTexture(id)
        glad_glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
    }
}

extension Texture {
    enum TextureError: Error {
        case loadfile(log: String)
    }
}