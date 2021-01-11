import LIBC
import SwiftOpenGL.gl
import Foundation

class SimpleObject {
    var VBO = UInt32(0)
    var EBO = UInt32(0)
    var VAO = UInt32(0)
    var program: GLSLProgram
    var texture = UInt32(0)
    var texture1 = UInt32(0)

    init() throws {
        let shaderPath = FileManager.default.currentDirectoryPath
            .appendingPathComponent("data")
            .appendingPathComponent("shader")

        let vertexShader = try Shader(
            url: URL(fileURLWithPath: shaderPath.appendingPathComponent("shader.vs")),
            type: GLenum(GL_VERTEX_SHADER))
        try vertexShader.compile()

        let fragmentShader = try Shader(
            url: URL(fileURLWithPath: shaderPath.appendingPathComponent("shader.fs")),
            type: GLenum(GL_FRAGMENT_SHADER))
        try fragmentShader.compile()

        self.program = GLSLProgram()
        self.program.attachShader(shader: vertexShader)
        self.program.attachShader(shader: fragmentShader)
        try self.program.link()

        glad_glGenBuffers(1, &self.VBO)
        glad_glGenBuffers(1, &self.EBO)
        glad_glGenVertexArrays(1, &self.VAO)
        
        self.bind()
        self.loadTexture()
    }

    private func bind() {

        let vertices = [
            Float(0.5), Float(0.5), Float(0.0), Float(1.0), Float(0.0), Float(0.0), Float(1.0), Float(1.0),
            Float(0.5), Float(-0.5), Float(0.0), Float(0.0), Float(1.0), Float(0.0), Float(1.0), Float(0.0),
            Float(-0.5), Float(-0.5), Float(0.0), Float(0.0), Float(0.0), Float(1.0), Float(0.0), Float(0.0),
            Float(-0.5), Float(0.5), Float(0.0), Float(0.0), Float(0.0), Float(1.0),  Float(0.0), Float(1.0),]
        let indices = [
            UInt32(0), UInt32(1), UInt32(3),
            UInt32(1), UInt32(2), UInt32(3)]

        glad_glBindVertexArray(self.VAO)

        glad_glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.VBO)
        glad_glBufferData(GLenum(GL_ARRAY_BUFFER),
            vertices.count * MemoryLayout<Float>.size,
            vertices, GLenum(GL_STATIC_DRAW))
        
        glad_glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            GLsizei(8 * MemoryLayout<Float>.size),
            UnsafeRawPointer(bitPattern: 0))
        glad_glEnableVertexAttribArray(0)
        
        glad_glVertexAttribPointer(1, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            GLsizei(8 * MemoryLayout<Float>.size),
            UnsafeRawPointer(bitPattern: 3 * MemoryLayout<Float>.size))
        glad_glEnableVertexAttribArray(1)

        glad_glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
            GLsizei(8 * MemoryLayout<Float>.size),
            UnsafeRawPointer(bitPattern: 6 * MemoryLayout<Float>.size))
        glad_glEnableVertexAttribArray(2)

        glad_glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)

        glad_glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.EBO)
        glad_glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
            indices.count * MemoryLayout<UInt32>.size,
            indices, GLenum(GL_STATIC_DRAW))
            
        glad_glBindVertexArray(0)
    }

    func loadTexture() {

        let image = FileManager.default.currentDirectoryPath
            .appendingPathComponent("data")
            .appendingPathComponent("image")
            .appendingPathComponent("wall.jpeg")

        glad_glGenTextures(1, &self.texture)
        glad_glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)

        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT);	
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT);
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);

        var width = Int32(0)
        var height = Int32(0)
        var nrChannels  = Int32(0)
        stbi_set_flip_vertically_on_load(Int32(1))
        let data = stbi_load(image, &width, &height, &nrChannels, 0)
        if data != nil {
            glad_glTexImage2D(GLenum(GL_TEXTURE_2D), GLint(0), GLint(GL_RGB),
                GLsizei(width), GLsizei(height),
                GLint(0), GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), data)
            glad_glGenerateMipmap(GLenum(GL_TEXTURE_2D))
        } else {
            print("Error load image \(image)")
        }
        stbi_image_free(data)

        let image1 = FileManager.default.currentDirectoryPath
            .appendingPathComponent("data")
            .appendingPathComponent("image")
            .appendingPathComponent("ninja.jpeg")

        glad_glGenTextures(1, &self.texture1)
        glad_glBindTexture(GLenum(GL_TEXTURE_2D), self.texture1)

        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT);	
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT);
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glad_glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);

        var width1 = Int32(0)
        var height1 = Int32(0)
        var nrChannels1  = Int32(0)
        stbi_set_flip_vertically_on_load(Int32(1))
        let data1 = stbi_load(image1, &width1, &height1, &nrChannels1, 0)
        if data1 != nil {
            glad_glTexImage2D(GLenum(GL_TEXTURE_2D), GLint(0), GLint(GL_RGB),
                GLsizei(width1), GLsizei(height1),
                GLint(0), GLenum(GL_RGB), GLenum(GL_UNSIGNED_BYTE), data1)
            glad_glGenerateMipmap(GLenum(GL_TEXTURE_2D))
        } else {
            print("Error load image \(image1)")
        }
        stbi_image_free(data1)
    }

    func draw() {
        self.program.use()
        let timeValue = glfwGetTime()
        let greenValue = (sin(timeValue) / 2.0) + 0.5
        self.program.setUniform(name: "greenValue", value: Float(greenValue))

        self.program.setUniform(name: "ourTexture", value: Int32(0))
        self.program.setUniform(name: "ourTexture1", value: Int32(1))

        glad_glActiveTexture(GLenum(GL_TEXTURE0))
        glad_glBindTexture(GLenum(GL_TEXTURE_2D), self.texture)
        glad_glActiveTexture(GLenum(GL_TEXTURE1))
        glad_glBindTexture(GLenum(GL_TEXTURE_2D), self.texture1)

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