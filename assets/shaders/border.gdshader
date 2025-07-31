shader_type canvas_item;

uniform vec4 dot_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float radius : hint_range(0.0, 1.0) = 0.4;
uniform float thickness : hint_range(0.001, 0.1) = 0.02;
uniform int dot_count : hint_range(1, 100) = 32;
uniform float gap_ratio : hint_range(0.0, 1.0) = 0.5;
uniform float rotation : hint_range(0.0, 6.2831) = 0.0; // Rotation in radians

void fragment() {
    // Convert UV from [0,1] to [-1,1], with center at (0,0)
    vec2 centered_uv = (UV - vec2(0.5)) * 2.0;

    float dist = length(centered_uv);
    float angle = atan(centered_uv.y, centered_uv.x) + rotation;

    // Normalize angle to [0,1]
    angle = mod(angle, 6.2831) / 6.2831;

    float segment = angle * float(dot_count);
    float dot_id = floor(segment);
    float local_angle = fract(segment);

    float mask = step(local_angle, 1.0 - gap_ratio);

    float ring = smoothstep(radius + thickness, radius, dist) *
                 smoothstep(radius - thickness, radius, dist);

    COLOR = dot_color * ring * mask;
}
