shader_type canvas_item;

// Mismos valores que el material del Fish Eye de pantalla
uniform float effect_amount = 1.4;
uniform vec2 screen_size = vec2(1920.0, 1080.0);
// Rectángulo del lens en pantalla, en píxeles: (x, y, ancho, alto)
uniform vec4 lens_rect = vec4(480.0, 270.0, 960.0, 540.0);

varying vec4 v_modulate;

void vertex() {
	v_modulate = COLOR;   // conserva el modulate (tu tween de revelado)
}

// La misma fórmula que fisheye.gdshader, pero sobre UV de pantalla (0..1)
vec2 fisheye(vec2 screen_uv) {
	float prop = screen_size.x / screen_size.y;
	vec2 m = vec2(0.5, 0.5 / prop);
	vec2 d = vec2(screen_uv.x, screen_uv.y / prop) - m;
	float r = length(d);
	if (r < 0.00001 || effect_amount == 0.0) return screen_uv;

	vec2 uv;
	if (effect_amount > 0.0) {
		float bind = length(m);
		uv = m + normalize(d) * tan(r * effect_amount) * bind / tan(bind * effect_amount);
	} else {
		float bind = prop < 1.0 ? m.x : m.y;
		uv = m + normalize(d) * atan(r * -effect_amount * 10.0) * bind / atan(-effect_amount * bind * 10.0);
	}
	uv.y *= prop;
	return uv;
}

void fragment() {
	vec2 screen_uv = (lens_rect.xy + UV * lens_rect.zw) / screen_size;  // UV de la foto → UV de pantalla
	vec2 src_uv = fisheye(screen_uv);                                   // dónde lee el ojo de pez
	vec2 photo_uv = (src_uv * screen_size - lens_rect.xy) / lens_rect.zw; // → UV de la captura
	COLOR = texture(TEXTURE, photo_uv) * v_modulate;
}