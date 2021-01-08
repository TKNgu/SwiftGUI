import GLAD
import SwiftOpenGL.glfw
import SwiftOpenGL.gl
// import Foundation
import Foundation

class App {
    let glfwEnviroment: GLFW
    let window: Window

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
    }

    func processInput() {
        if self.window.isKeyPress(key: GLFW_KEY_ESCAPE) {
            self.window.close()
        }
    }

    func compileShader(source: String, type: GLenum) throws -> UInt32 {
        var arraySourceShader = [UnsafePointer<Int8>(source.cString(using: String.Encoding.utf8))]
        var shader = glad_glCreateShader(type)
        glad_glShaderSource(shader, 1, &arraySourceShader, nil)
        glad_glCompileShader(shader)

        var success = Int32(1)
        var infoLog = [Int8](repeating: 0, count: 512)
        glad_glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &success);
        if success == 0 {
            glad_glGetShaderInfoLog(shader, 512, nil, &infoLog);
            throw GLADError.buildShader(log: String(cString: infoLog))
        } else {
            print("OK")
        }
        return shader
    }

    func mainLoop() throws {

        var vertices = [Float(-0.5), Float(-0.5), Float(0.0),
            Float(0.5), Float(-0.5), Float(0.0),
            Float(0.0), Float(0.5), Float(0.0)]
        var VBO = UInt32(0)
        glad_glGenBuffers(1, &VBO)
        glad_glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glad_glBufferData(GLenum(GL_ARRAY_BUFFER),
            vertices.count * MemoryLayout<Float>.size,
            &vertices, GLenum(GL_STATIC_DRAW))

        var vertexShaderSource = """
        #version 330 core
        layout (location = 0) in vec3 aPos;
        void main(){
            gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
        };
        """
        let vertexShader = try compileShader(source: vertexShaderSource, type: GLenum(GL_VERTEX_SHADER))


        var fragmentShaderSource = """
        #version 330 core\n
        out vec4 FragColor;\n
        void main()\n
        {\n
            FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n
        }
        """
        print(fragmentShaderSource)
        let fragmentShader = try compileShader(source: fragmentShaderSource, type: GLenum(GL_FRAGMENT_SHADER))

        var shaderProgram = glad_glCreateProgram()
        glad_glAttachShader(shaderProgram, vertexShader)
        glad_glAttachShader(shaderProgram, fragmentShader)
        glad_glLinkProgram(shaderProgram)

        var success = Int32(1)
        var infoLog = [Int8](repeating: 0, count: 512)
        glad_glGetProgramiv(shaderProgram, GLenum(GL_LINK_STATUS), &success);
        if success == 0 {
            glad_glGetProgramInfoLog(shaderProgram, 512, nil, &infoLog);
            print(String(cString: infoLog))
        }
        glad_glUseProgram(shaderProgram)
        glad_glDeleteShader(vertexShader)
        glad_glDeleteShader(fragmentShader)

        glad_glVertexAttribPointer(GLuint(0), GLint(3), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(3 * MemoryLayout<Float>.size), UnsafeRawPointer(bitPattern: 0))
        glad_glEnableVertexAttribArray(0)
        glad_glUseProgram(shaderProgram)
        // glad_someOpenGLFunctionThatDrawsOurTriangle()

        while self.window.shouldClose() {
            processInput()
            self.window.swapBuffer()
            glad_glClearColor(Float(0.2), Float(0.3), Float(0.3), Float(1.0))
            glad_glClear(UInt32(GL_COLOR_BUFFER_BIT))
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
} catch {
    print("Error")
}