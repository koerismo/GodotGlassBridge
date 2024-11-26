#include "gdexample.h"
#include <godot_cpp/classes/node3d.hpp>

using namespace godot;

GDExample::GDExample() {
	t = 0.0;
}

GDExample::~GDExample() {
}

void GDExample::_bind_methods() {
	ClassDB::bind_method(D_METHOD("get_testProp"), &GDExample::get_testProp);
	ClassDB::bind_method(D_METHOD("set_testProp", "p_testProp"), &GDExample::set_testProp);
	ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "testProp"), "set_testProp", "get_testProp");
}

void GDExample::_process(double delta) {
}

double GDExample::get_testProp() const {
	return t;
}

void GDExample::set_testProp(const double p_testProp) {
	t = p_testProp;
}
