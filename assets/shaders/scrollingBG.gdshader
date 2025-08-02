shader_type canvas_item;



uniform float speedX;
uniform float speedY;

void fragment () {
	COLOR = texture(TEXTURE, vec2(UV.x + TIME * speedX, UV.y + TIME * speedY));
}