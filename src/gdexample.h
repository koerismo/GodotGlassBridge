#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <godot_cpp/classes/node3d.hpp>

namespace godot {

	class GDExample : public Node3D {
		GDCLASS(GDExample, Node3D)

	private:
		double t;

	protected:
		static void _bind_methods();
	
	public:
		GDExample();
		~GDExample();

		void _process(double delta) override;

		double get_testProp() const;
		void set_testProp(const double p_testProp);
	};

}

#endif