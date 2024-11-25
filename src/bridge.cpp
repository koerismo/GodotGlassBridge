#include <glfw/glfw3.h>
#include <glad/glad.h>
// #include <bridge.h>
// #include <bridge_utils.hpp>

// https://docs.lookingglassfactory.com/core/looking-glass-bridge-sdk/integrating-native-applications#configure-a-shared-gpu-rendering-context

int initGlass() {

	// initialize glfw
	if (!glfwInit()) return -1;

	// create preview window
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	GLFWwindow* window = glfwCreateWindow(800, 800, "Bridge SDK example", nullptr, nullptr);

	if (!window) {
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window);
}

