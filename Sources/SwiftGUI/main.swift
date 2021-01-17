import LIBC
import SwiftOpenGL.glfw
import SwiftOpenGL.gl
import Foundation

class App {
    let glfwEnviroment: GLFW
    let window: Window
    let simpleObject: SimpleObject

    init() throws {
        self.glfwEnviroment = try GLFW(major: 3, minor: 3, profile: GLFW_OPENGL_CORE_PROFILE)
        self.window = try Window(width: 800, height: 600, name: "LearnOpenGL")
        self.glfwEnviroment.makeContextCurrent(window: self.window)
        self.window.setSizeCallback(callback: { (window: OpaquePointer?, width: Int32, height: Int32) in
            glad_glViewport(0, 0, width, height);
        })
        if initGLAD() == 0 {
            throw GLADError.initGlad
        }
        self.simpleObject = try SimpleObject()
    }

    func processInput() {
        if self.window.isKeyPress(key: GLFW_KEY_ESCAPE) {
            self.window.close()
        }
    }

    func mainLoop() throws {

        var nrAttributes = Int32(0)
        glad_glGetIntegerv(GLenum(GL_MAX_VERTEX_ATTRIBS), &nrAttributes)
        print("Max \(nrAttributes)")

        while self.window.shouldClose() {
            processInput()

            glad_glClearColor(Float(0.2), Float(0.3), Float(0.3), Float(1.0))
            glad_glClear(UInt32(GL_COLOR_BUFFER_BIT))

            // glad_glPolygonMode(GLenum(GL_FRONT_AND_BACK), GLenum(GL_LINE))
            glad_glPolygonMode(GLenum(GL_FRONT_AND_BACK), GLenum(GL_FILL))
            self.simpleObject.draw()

            self.window.swapBuffer()
            glfwPollEvents()
        }
    }
}

extension App {
    enum GLADError: Error {
        case initGlad
        case buildShader(log: String)
    }
}

do {
    let app = try App()
    try app.mainLoop()
} catch App.GLADError.buildShader(let log) {
    print(log)
} catch GLSLProgram.GLSLProgramError.link(let log) {
    print(log)
} catch Shader.ShaderError.compile(let log) {
    print(log)
} catch Texture.TextureError.loadfile(let log) {
    print(log)
} catch {
    print("Error")
}