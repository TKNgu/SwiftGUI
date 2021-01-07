import SwiftOpenGL.glfw
import SwiftOpenGL.gl
import GLAD
import Glibc

func framebuffer_size_callback(window: OpaquePointer?, width: Int32, height: Int32) {
    glViewport(0, 0, width, height);
} 

func processInput(window: OpaquePointer?) {
    if glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS {
        glfwSetWindowShouldClose(window, Int32(1))
    }
}

func main() {
    print("Hello OpenGL")
    if glfwInit() == GL_FALSE {
        print("Error init OpenGL")
        return
    }
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)


    let window = glfwCreateWindow(800, 600, "LearnOpenGL", nil, nil)
    print(window)
    if window == nil {
        print("Failed to create GLFW window")
        glfwTerminate()
        return
    }
    glfwMakeContextCurrent(window)
    if initGLAD() == 0 {
        print("Failed to initialize GLAD")
        return
    }
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback)
    while glfwWindowShouldClose(window) == 0 {
        processInput(window: window)
        glfwSwapBuffers(window)
        glClearColor(Float(0.2), Float(0.3), Float(0.3), Float(1.0))
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        glfwPollEvents()
    }

    glfwTerminate()
    return
}

main()