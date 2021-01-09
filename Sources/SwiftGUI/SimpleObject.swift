import GLAD
import SwiftOpenGL.gl

class SimpleObject {
    var VBO = UInt32(0)
    var EBO = UInt32(0)
    var VAO = UInt32(0)
    var program: GLSLProgram

    init() throws {
        var vertexShaderSource = """
        #version 330 core
        layout (location = 0) in vec3 aPos;
        void main(){
            gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
        };
        """
        var vertexShader = Shader(source: vertexShaderSource,
            type: GLenum(GL_VERTEX_SHADER))
        try vertexShader.compile()

        var fragmentShaderSource = """
        #version 330 core\n
        out vec4 FragColor;\n
        void main()\n
        {\n
            FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n
        }
        """
        var fragmentShader = Shader(source: fragmentShaderSource,
            type: GLenum(GL_FRAGMENT_SHADER))
        try fragmentShader.compile()

        self.program = GLSLProgram()
        self.program.attachShader(shader: vertexShader)
        self.program.attachShader(shader: fragmentShader)
        try self.program.link()

        var vertices = [Float(0.5), Float(0.5), Float(0.0),
            Float(0.5), Float(-0.5), Float(0.0),
            Float(-0.5), Float(-0.5), Float(0.0),
            Float(-0.5), Float(0.5), Float(0.0)]
        var indices = [UInt32(0), UInt32(1), UInt32(3),
            UInt32(1), UInt32(2), UInt32(3)]
        glad_glGenBuffers(1, &self.VBO)
        glad_glGenBuffers(1, &self.EBO)
        glad_glGenVertexArrays(1, &self.VAO)

        glad_glBindVertexArray(self.VAO)
        glad_glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glad_glBufferData(GLenum(GL_ARRAY_BUFFER),
            vertices.count * MemoryLayout<Float>.size,
            vertices, GLenum(GL_STATIC_DRAW))
        glad_glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            GLsizei(3 * MemoryLayout<Float>.size), UnsafeRawPointer(bitPattern: 0))
        glad_glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)

        glad_glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        glad_glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
            indices.count * MemoryLayout<UInt32>.size,
            indices, GLenum(GL_STATIC_DRAW))
        glad_glEnableVertexAttribArray(0)
        glad_glBindVertexArray(0)
    }

    func draw() {
        self.program.use()
        glad_glBindVertexArray(self.VAO)
        glad_glDrawElements(GLenum(GL_TRIANGLES), GLsizei(6),
            GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
    }

    deinit {
        glad_glDeleteVertexArrays(1, &self.VAO)
        glad_glDeleteBuffers(1, &self.VBO)
        glad_glDeleteBuffers(1, &self.EBO)
    }
}