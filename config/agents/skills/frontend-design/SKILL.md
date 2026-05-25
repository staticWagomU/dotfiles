---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.
license: Complete terms in LICENSE.txt
---

<purpose>
Guide creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.
</purpose>

<rules priority="critical">
  <rule>Before coding, understand context and commit to a BOLD aesthetic direction</rule>
  <rule>Choose a clear conceptual direction and execute it with precision</rule>
  <rule>NEVER use generic AI-generated aesthetics: overused fonts (Inter, Roboto, Arial, system fonts), cliched color schemes (particularly purple gradients on white backgrounds), predictable layouts, cookie-cutter design</rule>
  <rule>NEVER converge on common choices (Space Grotesk, for example) across generations</rule>
  <rule>Match implementation complexity to the aesthetic vision</rule>
</rules>

<patterns>
  <pattern name="design-thinking">
    <description>Pre-coding design analysis</description>
    <steps>
      1. Purpose: What problem does this interface solve? Who uses it?
      2. Tone: Pick an extreme - brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc.
      3. Constraints: Technical requirements (framework, performance, accessibility)
      4. Differentiation: What makes this UNFORGETTABLE? What's the one thing someone will remember?
    </steps>
  </pattern>

  <pattern name="implementation">
    <description>Code output requirements</description>
    <criteria>
      - Production-grade and functional
      - Visually striking and memorable
      - Cohesive with a clear aesthetic point-of-view
      - Meticulously refined in every detail
    </criteria>
  </pattern>
</patterns>

<best_practices>
  <practice priority="critical">Typography: Choose beautiful, unique, interesting fonts. Avoid generic fonts. Pair a distinctive display font with a refined body font.</practice>
  <practice priority="critical">Color and Theme: Commit to a cohesive aesthetic. Use CSS variables. Dominant colors with sharp accents outperform timid, evenly-distributed palettes.</practice>
  <practice priority="high">Motion: Use animations for effects and micro-interactions. Prioritize CSS-only for HTML, Motion library for React. Focus on high-impact moments: one well-orchestrated page load with staggered reveals creates more delight than scattered micro-interactions.</practice>
  <practice priority="high">Spatial Composition: Unexpected layouts, asymmetry, overlap, diagonal flow, grid-breaking elements, generous negative space OR controlled density.</practice>
  <practice priority="high">Backgrounds and Visual Details: Create atmosphere and depth. Apply gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, grain overlays.</practice>
  <practice priority="medium">Vary between light and dark themes, different fonts, different aesthetics across designs. No two designs should look the same.</practice>
</best_practices>

<anti_patterns>
  <avoid name="Generic AI aesthetics">
    <description>Overused font families, cliched color schemes, predictable layouts, cookie-cutter design lacking context-specific character</description>
    <instead>Interpret creatively and make unexpected choices that feel genuinely designed for the context</instead>
  </avoid>
  <avoid name="Mismatched complexity">
    <description>Maximalist designs with minimal code, or minimalist designs with excessive effects</description>
    <instead>Maximalist designs need elaborate code with extensive animations. Minimalist designs need restraint, precision, and careful attention to spacing, typography, and subtle details.</instead>
  </avoid>
</anti_patterns>

<constraints>
  <must>Implement working code (HTML/CSS/JS, React, Vue, etc.)</must>
  <must>Every design must have a clear conceptual direction</must>
  <avoid>Generic fonts (Inter, Roboto, Arial, system fonts)</avoid>
  <avoid>Purple gradients on white backgrounds</avoid>
  <avoid>Predictable layouts and component patterns</avoid>
</constraints>
