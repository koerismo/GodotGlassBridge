#include "gdglass.h"
#include <godot_cpp/classes/node3d.hpp>

using namespace godot;

void GDExample::_bind_methods() {
}

GDExample::GDExample() {
	t = 0.0;
	printf("Hello!!!\n");
}

GDExample::~GDExample() {
}

void GDExample::_process(double delta) {
	t += delta;
}
