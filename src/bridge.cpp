#include <glad/glad.h>
#include <glfw/glfw3.h>
#include <bridge.h>
#include <bridge_utils.hpp>

// https://docs.lookingglassfactory.com/core/looking-glass-bridge-sdk/integrating-native-applications#configure-a-shared-gpu-rendering-context

int initGL() {

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

int initBridge() {
	initialize_bridge((wchar_t*)("Bridge SDK Example"));

	// query the available Looking Glass displays
	int lkg_display_count = 0;
	std::vector<unsigned long> lkg_displays;
	get_displays(&lkg_display_count, nullptr);
	lkg_displays.resize(lkg_display_count);
	get_displays(&lkg_display_count, lkg_displays.data());

	// perform any desired queries on the Looking Glass displays
	std::wstring serial;
	std::vector<std::wstring> lkg_display_serials;
	int serial_count = 0;

	// query all connected Looking Glass displays
	for (auto it : lkg_displays) {
		get_device_serial_for_display(it, &serial_count, nullptr);
		serial.resize(serial_count);
		get_device_serial_for_display(it, &serial_count, serial.data());
		lkg_display_serials.push_back(serial);
	}

	// Note: callers are required to allocate enough memory for return parameters \
	of variable length

	// create window using configuration from the target Looking Glass display
	unsigned long lkg_wnd;
	instance_window_gl(&lkg_wnd, lkg_displays.front());
}
