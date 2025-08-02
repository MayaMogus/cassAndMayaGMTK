shader_type canvas_item;

uniform vec4 square_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 background_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float square_size = 32.0;
uniform float padding = 4.0;
uniform float speedX = 10.0;
uniform float speedY = 0.0;

void fragment() {
    // Apply scrolling to FRAGCOORD
    vec2 scrolled_coord = FRAGCOORD.xy + vec2(TIME * speedX, TIME * speedY);

    // Get local position in the grid
    vec2 cell_pos = mod(scrolled_coord, square_size);

    // Draw based on padding
    if (cell_pos.x < padding || cell_pos.y < padding ||
        cell_pos.x > (square_size - padding) || cell_pos.y > (square_size - padding)) {
        COLOR = background_color;
    } else {
        COLOR = square_color;
    }
}
