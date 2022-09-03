def test_muxers()
  { r: 23, g: 34, b: 45 }.or_demux(rgb: %i[r g b]).or_mux(color: %i[r g b])
end
