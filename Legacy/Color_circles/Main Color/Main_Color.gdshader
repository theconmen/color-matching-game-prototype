shader_type canvas_item;

uniform vec4 override_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = vec4(override_color.rgb, tex_color.a * override_color.a);
}


