#include "include/wrap.h"
#include "include/glad/glad.h"
#include <GLFW/glfw3.h>

int initGLAD() {
    return gladLoadGLLoader((GLADloadproc)glfwGetProcAddress);
}