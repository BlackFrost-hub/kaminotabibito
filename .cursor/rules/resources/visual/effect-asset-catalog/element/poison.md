# Poison Effects

| Game path | Visual | Usage | Texture notes | Size | SHA-256 (first 16) |
| --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Element\poison\MiaSlimeBurstGround.mdx` | Flat green corruption ripple and ground burst. | Mia P3 Corrupt Slime Coating global throw, layered at the Boss. | One private shockwave texture is stored in `Element\poison\Texture`; the flare and second shockwave reuse verified existing project textures; native `Textures\Flare.blp` and `Textures\Pixies1.blp` retain their game paths. | 3739 | `9B5F005948DED58F` |
| `Common\Effect\Element\poison\MiaSlimeBurstFlash.mdx` | Green radial flash burst. | Mia P3 Corrupt Slime Coating global throw, layered at the Boss. | Uses source native `Textures\...` paths unchanged. | 18091 | `1AACBBF91A843F97` |
| `Common\Effect\Element\poison\MiaCorruptionStackBurst.mdx` | Vertical green corruption eruption. | Plays once at a unit when Mia Corruption Infection gains one or more actual stacks. | Uses source native `Textures\...` paths; the source desktop `RingOFire` reference is restored to `Textures\RingOFire.blp`. | 6562 | `AF0AF0495D27029A` |
