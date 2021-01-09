import GLAD
import SwiftOpenGL.gl

class GLSLProgram {
    let program: GLuint

    init() {
        self.program = glad_glCreateProgram()
    }

    func attachShader(shader: Shader) {
        glad_glAttachShader(self.program, shader.shader)
    }

    func link() throws {
        glad_glLinkProgram(self.program)
        var success = Int32(0)
        var infoLog = [Int8](repeating: 0, count: 512)
        glad_glGetProgramiv(self.program, GLenum(GL_LINK_STATUS), &success)
        if success == 0 {
            glad_glGetProgramInfoLog(self.program, 512, nil, &infoLog)
            throw GLSLProgramError.link(log: String(cString: infoLog))
        }
    }

    func use() {
        glad_glUseProgram(self.program)
    }

    deinit {
        glad_glDeleteProgram(self.program)
    }
}

extension GLSLProgram {
    enum GLSLProgramError: Error {
        case link(log: String)
    }
}