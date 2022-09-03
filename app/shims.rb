module Vec2Shim
  def -@()
    Matrix.vec2(-self[:x], -self[:y])
  end

  def +(other)
    if Vec2 === other
      super
    elsif Numeric === other
      super(Matrix.vec2(other, other))
    else
      super || (raise ArgumentError)
    end
  end

  def *(other)
    if Vec2 === other
      super
    elsif Numeric === other
      Matrix.vec2(self[:x] * other, self[:y] * other)
    else
      super || (raise ArgumentError)
    end
  end

  def -(other)
    self + (other * -1)
  end

  def /(other)
    if Numeric === other
      Matrix.vec2(self[:x] / other, self[:y] / other)
    elsif Vec2 === other
      Matrix.vec2(self[:x] / other[:x], self[:y] / other[:y])
    else
      raise ArgumentError
    end
  end

  def rot(theta)
    c = Math.cos(theta)
    s = Math.sin(theta)

    rm = Matrix.mat2(c, -s,
                     s, c)

    self * rm
  end

  def sq_abs()
    self[:x] * self[:x] + self[:y] * self[:y]
  end

  def abs()
    Math.sqrt(self[:x] * self[:x] + self[:y] * self[:y])
  end
end

Vec2.prepend Vec2Shim

module HashShim
  def or_demux!(**vs)
    demux(vs.map { |k, v| [k, v.delete_if { self.key? _1 }] }.to_h)
  end

  def demux!(**vs)
    vs.each { |k, dk|
      sv = self[k]
      if Array === sv
        raise ArgumentError unless sv.size == dk.size
        dk.zip(sv).each { |k, v|
          self[k] = v
        }
      else
        dk.each { |k|
          self[k] = sv
        }
      end
      self.delete(k)
    }

    self
  end

  def or_demux(**vs)
    demux(vs.map { |k, v| [k, v.delete_if { self.key? _1 }] }.to_h)
  end

  def demux(...)
    dup.demux!(...)
  end

  def or_mux!(**vs)
    mux!(vs.delete_if { |k, _| self.key? k })
  end

  def mux!(**vs)
    vs.each { |dk, sks|
      if Hash === sks
        self[dk] = sks.map { |k, v|
          [v, self[k]]
        }.to_h
      elsif Array === sks
        svs = values_at(*sks)
        raise ArgumentError unless svs.size == sks.size
        self[dk] = sks.zip(svs).to_h
      else
        raise ArgumentError
      end
    }

    vs.flat_map { |_, v|
      if Hash === v
        v.keys
      elsif Array === v
        v
      end
    }.each { self.delete(_1) }

    self
  end

  def or_mux(**vs)
    mux(vs.delete_if { |k, _| self.key? k })
  end

  def mux(...)
    dup.mux!(...)
  end
end

Hash.prepend HashShim

module NumericShim
  def normalize_rads()
    pi = Math::PI
    self - ((2 * pi) * (((self) + pi) / (2 * pi)).floor)
  end

  def sign()
    if negative?
      -1
    else
      1
    end
  end
end

Numeric.prepend NumericShim
