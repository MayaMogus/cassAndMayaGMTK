shader_type canvas_item;

uniform vec4 shine_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float cycle_interval : hint_range(0.1, 5.0) = 1.0;
uniform float shine_speed : hint_range(1.0, 5.0) = 3.0;
uniform float shine_width : hint_range(0.0, 2.0) = 0.5;
uniform float rotation_degrees : hint_range(0.0, 360.0) = 0.0;
uniform float show_only_shine : hint_range(0.0, 1.0, .25) = 0.0; // 0 = normal blend, 1 = only shine

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float angle = radians(rotation_degrees);

    vec2 rotated_uv = vec2(
        cos(angle) * UV.x - sin(angle) * UV.y,
        sin(angle) * UV.x + cos(angle) * UV.y
    );

    float sine_wave = sin(rotated_uv.y * cycle_interval * 6.2831 + TIME * shine_speed);

    float mask = step(1.0 - shine_width, sine_wave);

    // Blended color
    vec3 blended_rgb = mix(tex.rgb, shine_color.rgb, mask * shine_color.a);

    // Blended alpha (normal mode: opaque texture)
    float blended_alpha = tex.a;

    // Shine-only color
    vec3 shine_rgb = shine_color.rgb;
    float shine_alpha = mask * shine_color.a;

    // Choose between the two modes
    vec3 final_rgb = mix(blended_rgb, shine_rgb, show_only_shine);
    float final_alpha = mix(blended_alpha, shine_alpha, show_only_shine);

    COLOR = vec4(final_rgb, final_alpha);
}
