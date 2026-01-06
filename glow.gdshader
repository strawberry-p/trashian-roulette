shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0);
uniform float shine_speed : hint_range(0.0, 10.0) = 1.0;
uniform float shine_size : hint_range(0.01, 1.0) = 0.01;

void fragment() {
    if (distance(COLOR.rgb, vec3(1.0, 0.831, 0.0)) < 0.5) {
    	float shine = step(1.0 - shine_size, 0.5 + 0.5 * sin(UV.x - UV.y + TIME * shine_speed));
		COLOR.rgb += shine_color.rgb * shine * COLOR.a;
		COLOR.rgb += vec3(0.1, 0.1, 0.0);
    }
}