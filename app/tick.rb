include MatrixFunctions

$rc = PhysicsBody.from_hash(x: 630, y: 350,
                            w: 20,
                            h: 20,
                            r: 0x00,
                            g: 0xa0,
                            b: 0xc0)

def reset_b()
  $b = PhysicsBody.from_hash(x: 330, y: 350,
                             w: 20,
                             h: 20,
                             g: 0xa0,
                             b: 0xc0)
end

reset_b

def tick(args)
  args.outputs.background_color = [0x18] * 3
  $b.rigid_rotate_around($rc)
  $b.apply_force(vec2(0, -2))
  args.outputs.sprites << [$rc, $b]
  if args.inputs.keyboard.key_down.r
    reset_b
  end
end
