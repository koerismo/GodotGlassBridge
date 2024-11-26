#include "register_types.h"
#include "gdglass.h"

#include <gdextension_interface.h>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

void init_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) return;

	GDREGISTER_CLASS(GlassVolume3D);
}

void uninit_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
}

// Initialization.
extern "C" {
	GDExtensionBool GDE_EXPORT library_init(
										GDExtensionInterfaceGetProcAddress p_get_proc_address,
										const GDExtensionClassLibraryPtr p_library,
										GDExtensionInitialization *r_initialization) {

		godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

		init_obj.register_initializer(init_module);
		init_obj.register_terminator(uninit_module);
		init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
		return init_obj.init();
	}
}