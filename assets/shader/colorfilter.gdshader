shader_type canvas_item;

// Allows you to control the output color in the Shader Params in the Inspector.

uniform vec4 filter_color: source_color = vec4(1.0,0.0,0.0,1.0);
uniform sampler2D RED_TEXTURE;
uniform sampler2D NOISE_TEX;
void fragment() {
	// We sample the screen texture at this point, which has the Mask node's pixels
	// rendered on it.
	vec4 screen_color = texture(RED_TEXTURE, UV);
	vec4 noise_col = texture(NOISE_TEX, UV);
	COLOR = vec4(noise_col.r, noise_col.g, noise_col.b, screen_color.a);
}