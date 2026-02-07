---
name: draw-io
description: draw.io diagram creation, editing, and review. Use for .drawio XML editing, PNG conversion, layout adjustment, and AWS icon usage.
---

<purpose>
Guide draw.io diagram creation, editing, conversion, layout adjustment, and design best practices for .drawio XML files.
</purpose>

<rules priority="critical">
  <rule>Edit only `.drawio` files - never directly edit `.drawio.png` files</rule>
  <rule>Use auto-generated `.drawio.png` by pre-commit hook in slides</rule>
  <rule>Internal elements must have at least 30px margin from frame boundary</rule>
  <rule>Account for rounded corners (`rounded=1`) and stroke width</rule>
  <rule>Always visually verify PNG output for overflow</rule>
</rules>

<rules priority="standard">
  <rule>For Quarto slides, specify `defaultFontFamily` in mxGraphModel tag and `fontFamily` in each text element's style</rule>
  <rule>Always place arrows at back layer (position in XML right after Title)</rule>
  <rule>Position arrows to avoid overlapping with labels</rule>
  <rule>Keep arrow start/end at least 20px from label bottom edge</rule>
</rules>

<patterns>
  <pattern name="font-settings">
    <description>Font configuration for diagrams used in Quarto slides</description>
    <example>
```xml
&lt;mxGraphModel defaultFontFamily="Noto Sans JP" ...&gt;
```

Also explicitly specify `fontFamily` in each text element's style attribute:

```xml
style="text;html=1;fontSize=27;fontFamily=Noto Sans JP;"
```
    </example>
  </pattern>

  <pattern name="conversion-commands">
    <description>Converting .drawio files to PNG</description>
    <example>
```sh
# Convert all .drawio files
mise exec -- pre-commit run --all-files

# Convert specific .drawio file
mise exec -- pre-commit run convert-drawio-to-png --files assets/my-diagram.drawio

# Run script directly (using skill's script)
bash ~/.claude/skills/draw-io/scripts/convert-drawio-to-png.sh assets/diagram1.drawio
```
    </example>
    <internal_command>drawio -x -f png -s 2 -t -o output.drawio.png input.drawio</internal_command>
    <options>
      -x: Export mode
      -f png: PNG format output
      -s 2: 2x scale (high resolution)
      -t: Transparent background
      -o: Output file path
    </options>
  </pattern>

  <pattern name="coordinate-adjustment">
    <description>Adjusting element positions in .drawio XML</description>
    <steps>
      1. Open `.drawio` file in text editor (plain XML format)
      2. Find `mxCell` for element to adjust (search by `value` attribute for text)
      3. Adjust coordinates in `mxGeometry` tag (x, y, width, height)
      4. Run conversion and verify
    </steps>
    <note>Element center coordinate = `y + (height / 2)`. To align multiple elements, calculate and match center coordinates.</note>
  </pattern>

  <pattern name="arrow-connection-to-text">
    <description>For text elements, exitX/exitY don't work, so use explicit coordinates</description>
    <example>
```xml
&lt;mxCell id="arrow" style="..." edge="1" parent="1"&gt;
  &lt;mxGeometry relative="1" as="geometry"&gt;
    &lt;mxPoint x="1279" y="500" as="sourcePoint"/&gt;
    &lt;mxPoint x="119" y="500" as="targetPoint"/&gt;
    &lt;Array as="points"&gt;
      &lt;mxPoint x="1279" y="560"/&gt;
      &lt;mxPoint x="119" y="560"/&gt;
    &lt;/Array&gt;
  &lt;/mxGeometry&gt;
&lt;/mxCell&gt;
```
    </example>
  </pattern>

  <pattern name="edge-label-offset">
    <description>Adjust offset attribute to distance arrow labels from arrows</description>
    <example>
```xml
&lt;!-- Place above arrow (negative value to distance) --&gt;
&lt;mxPoint x="0" y="-40" as="offset"/&gt;

&lt;!-- Place below arrow (positive value to distance) --&gt;
&lt;mxPoint x="0" y="40" as="offset"/&gt;
```
    </example>
  </pattern>

  <pattern name="background-frame-placement">
    <description>Internal element placement inside background frames with proper margins</description>
    <example>
```xml
&lt;!-- Good: sufficient margin --&gt;
&lt;mxCell id="bg" style="rounded=1;strokeWidth=3;..."&gt;
  &lt;mxGeometry x="500" y="20" width="560" height="430" /&gt;
&lt;/mxCell&gt;
&lt;mxCell id="label" value="Title" style="text;..."&gt;
  &lt;mxGeometry x="510" y="50" width="540" height="35" /&gt;
&lt;/mxCell&gt;
```
    </example>
    <calculation>
Background frame: y=20, height=400 -> range is y=20-420
Internal element top: frame y + 30 or more (e.g., y=50)
Internal element bottom: frame y + height - 30 or less (e.g., up to y=390)
    </calculation>
  </pattern>
</patterns>

<best_practices>
  <practice priority="critical">Remove `background="#ffffff"` - transparent background adapts to various themes</practice>
  <practice priority="high">Use 1.5x standard font size (around 18px) for PDF readability</practice>
  <practice priority="high">Allow 30-40px per Japanese character width; insufficient width causes unintended line breaks</practice>
  <practice priority="high">XML layer order: Title -> Arrows (back layer) -> Other elements (front layer)</practice>
  <practice priority="medium">Remove decorative icons irrelevant to context (e.g., if ECR exists, separate Docker icon is unnecessary)</practice>
  <practice priority="medium">Service name only: 1 line. Service name + supplementary info: 2 lines with `&amp;lt;br&amp;gt;` tag</practice>
  <practice priority="medium">Add `auto-stretch: false` to YAML header for reveal.js slides to ensure correct image display on mobile</practice>
</best_practices>

<constraints>
  <must>Label all elements</must>
  <must>Use arrows to indicate direction (prefer 2 unidirectional arrows over bidirectional)</must>
  <must>Use latest official icons</must>
  <must>Ensure sufficient color contrast</must>
  <must>Use patterns in addition to colors for accessibility</must>
  <must>Include title, description, last updated, author, and version in diagrams</must>
  <avoid>Directly editing .drawio.png files</avoid>
  <avoid>Setting background color (use transparent)</avoid>
  <avoid>Placing elements within 30px of frame boundary</avoid>
</constraints>

<reference>
- [Layout Guidelines](references/layout-guidelines.md)
- [AWS Icons](references/aws-icons.md)
- [AWS Icon Search Script](scripts/find_aws_icon.py)

AWS icon search examples:
```sh
python ~/.claude/skills/draw-io/scripts/find_aws_icon.py ec2
python ~/.claude/skills/draw-io/scripts/find_aws_icon.py lambda
```
</reference>
