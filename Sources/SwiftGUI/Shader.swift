import GLAD
import SwiftOpenGL.gl

class Shader {
    let source: String
    let type: GLenum
    var shader: GLuint

    init(source: String, type: GLenum) {
        self.source = source
        self.type = type
        self.shader = glad_glCreateShader(self.type)
    }

    deinit {
        glad_glDeleteShader(self.shader)
    }

    func compile() throws {
        var arraySourceShader = [UnsafePointer<Int8>(self.source.cString(using: String.Encoding.utf8))]
        glad_glShaderSource(self.shader, 1, &arraySourceShader, nil)
        glad_glCompileShader(self.shader)
        var success = Int32(1)
        var infoLog = [Int8](repeating: 0, count: 512)
        glad_glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &success);
        if success == 0 {
            glad_glGetShaderInfoLog(shader, 512, nil, &infoLog);
            throw ShaderError.compile(log: String(cString: infoLog))
        }
    }
}

extension Shader {
    enum ShaderError: Error {
        case compile(log: String)
    }
}