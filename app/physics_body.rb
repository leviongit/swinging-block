class PhysicsBody
  attr_reader :x, :y, :w, :h, :v

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

    ffi.draw_line(
      @x + @w / 2,
      @y + @w / 2,
      @x + @w / 2 + @v[:x] * 5,
      @y + @w / 2 + @v[:y] * 5,
      0xff, 0xff, 0, 0xff
    )

    ffi.draw_line(
      @x + @w / 2,
      @y + @w / 2,
      @x + @w / 2 + @cf[:x] * 10,
      @y + @w / 2 + @cf[:y] * 10,
      0xff, 0x0, 0, 0xff
    ) if @cf
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
    rv = vec2(@x - body.x, @y - body.y)

    θv = Math.atan2(@v[:y], @v[:x])
    θr = Math.atan2(rv[:y], rv[:x])

    s1 = @v.abs / (ra = rv.abs)
    ω = s1 * (θv - θr).normalize_rads.sign

    p1 = rv.rot(ω)
    va = @v.abs

    @cf = (-rv / 2 * ω * ω)

    @v = normalize(@v + @cf) * va

    @v = @v.rot(ω)

    @x = p1[:x] + body.x
    @y = p1[:y] + body.y
  end
end
