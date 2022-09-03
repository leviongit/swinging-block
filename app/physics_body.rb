class PhysicsBody
  attr_reader :x, :y, :w, :h

  def initialize(x, y, w, h, color = {}, v = vec2(0, 0))
    @x = x
    @y = y
    @w = w
    @h = h
    @color = color
    @v = v
  end

  def self.from_hash(**h)
    self.new(h[:x], h[:y], h[:w], h[:h], h.or_demux(rgb: %i[r g b]).or_mux(color: %i[r g b])[:color], h[:v] || vec2(0, 0))
  end

  def draw_override(ffi)
    ffi.draw_sprite_3(
      @x, @y, @w, @h, "pixel",
      0, 0xff,       *@color.values_at(:r, :g, :b),
          *[nil] * 12
    )
  end

  def move_by(vec)
    @x += vec[:x]
    @y += vec[:y]
  end

  def move()
    @x += @v[:x]
    @y += @v[:y]
  end

  def apply_force(vec)
    @v += vec
  end

  def rigid_rotate_around(body)
    bv = vec2(body.x, body.y)
    rv = vec2(@x, @y) - bv
    ω = @v.abs / rv.abs
    p1 = rv.rot(ω) + bv
    @x, @y = p1.values_at(:x, :y)
    @v = @v.rot(ω)
  end
end
