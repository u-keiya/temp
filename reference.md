# Draw.io .drawio XML File Format Documentation

## Overview of .drawio XML Structure

A **.drawio** file (for diagrams.net / Draw.io) is essentially an XML document that encodes one or more diagrams. At the top level, it typically contains an `<mxfile>` element, which may include metadata like modified timestamp, application host, version, etc. Inside `<mxfile>` are one or more `<diagram>` elements (one per page/tab in the diagram file), each containing the diagram data. For a single-page diagram, there will be one `<diagram>` node (named by default "Page-1"). For multi-page diagrams, multiple `<diagram>` entries appear sequentially. For example:

    <?xml version="1.0" encoding="UTF-8"?>
    <mxfile modified="2019-08-01T09:23:36.597Z" version="10.9.5" type="device">
        <diagram id="SGW9pF4..." name="Page-1">
            <!-- Diagram content (possibly compressed) -->
        </diagram>
    </mxfile>

Each `<diagram>` has an **id** (unique identifier for that page) and a **name** (the page title). If the diagram content is stored uncompressed (more on compression later), the `<diagram>` element will directly contain an `<mxGraphModel>` XML structure describing the diagram. If compressed, the `<diagram>` text will be a compressed Base64 string instead of readable XML. Multiple pages are supported by including multiple `<diagram>` entries within the single `<mxfile>` wrapper.

## The `<mxGraphModel>` and Root Structure

The core of the diagram is encapsulated in `<mxGraphModel>` tags, which define the graph model of the diagram. This is the root of the actual diagram content, containing global attributes and a nested `<root>` element that holds all the diagram's cells (shapes, connectors, etc.). An example of an `<mxGraphModel>` start tag with common attributes is shown below:

    <mxGraphModel dx="946" dy="469" grid="1" gridSize="10" guides="1" 
                  tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" 
                  pageWidth="1100" pageHeight="850" background="#ffffff" math="0" shadow="0">
        <root>
            <mxCell id="0"/>
            <mxCell id="1" parent="0"/>
            <!-- ... other cells ... -->
        </root>
    </mxGraphModel>

Let’s break down the key attributes of `<mxGraphModel>`:

- **dx, dy** – Diagram dimensions or the current scrollable area size (in pixels). These often represent the diagram’s width (`dx`) and height (`dy`) as last recorded by the editor. They are not critical for correctness but indicate canvas extents or translation.
- **grid** – If `"1"`, the drawing grid is enabled/visible; `"0"` means grid off.
- **gridSize** – The grid spacing in pixels (default often 10).
- **guides** – `"1"` to enable alignment guides (snapping to guide lines), `"0"` to disable.
- **tooltips** – `"1"` to show tooltips on hover for elements, `"0"` to disable.
- **connect** – `"1"` allows connector arrows to connect between shapes (i.e., ports/perimeter), `"0"` would disable connection snapping.
- **arrows** – `"1"` shows direction arrows on connectors by default (when relevant), `"0"` hides them.
- **fold** – `"1"` allows folding (collapsing/expanding) of group or container shapes (like swimlanes), `"0"` disables that feature.
- **page** – `"1"` if a page layout with page boundaries is enabled (in which case pageWidth/pageHeight define the page size), or `"0"` for an infinite canvas.
- **pageScale** – The scaling factor for the page (usually `1` for 100% scale).
- **pageWidth, pageHeight** – The dimensions of the page (if page mode is on) in pixels. For example, `pageWidth="1100" pageHeight="850"` could correspond to a standard page size.
- **background** – The background color of the diagram/page, given as a hex color code (e.g., `#ffffff` for white). This is the page background when page mode is on.
- **math** – `"1"` enables MathJax for rendering LaTeX within labels, `"0"` means math typesetting is off.
- **shadow** – `"1"` if a drop-shadow effect is applied by default to shapes, `"0"` for no shadow by default.

Following these attributes, the `<mxGraphModel>` contains a `<root>` element. The `<root>` holds a collection of `<mxCell>` elements, which represent all nodes and edges in the diagram. The first two cells in `<root>` are always special placeholders: the cell with **id="0"** represents the invisible root of the graph, and the cell with **id="1"** is the default parent for all top-level shapes (essentially the first layer of the diagram). These must be present in every diagram model:

    <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <!-- Other cells will be children of id="1" or other layers/groups -->
    </root>

Here, the cell with `id="1"` has `parent="0"`, indicating it’s a direct child of the root (thus representing the primary layer). All other diagram elements (shapes, connectors, groups, additional layers) will be descendants of either id "1" or another layer’s id.

**Multiple Layers:** Draw.io supports multiple named layers. Each layer is represented as an `<mxCell>` with `parent="0"` (meaning it’s a top-level child of the root, like the default layer). The first layer (id "1") often has no `value` (name) and is the default layer. Additional layers can be created; these will appear as sibling `<mxCell>` entries under the root with `parent="0"` and typically a `value` attribute holding the layer’s name. For example, a second layer might appear as:

    <mxCell id="3" value="Untitled Layer" parent="0"/>

In this example, `id="3"` is another layer (with name "Untitled Layer") separate from the default layer (id "1"). Any shapes intended to be on that layer would have `parent="3"`. Layer ordering in the XML is the order in which these cells appear under `<root>` (which usually corresponds to creation order; the drawing engine uses this order to determine layer front/back ordering). There are no explicit XML attributes for layer visibility or locking – hidden/locked layer state is not directly stored in the .drawio XML; those are managed by the editor. (If a layer name contains special characters, it will be stored in the `value` as escaped HTML text.)

## `<mxCell>` Elements and Diagram Components

Each shape, text label, or connector in the diagram is represented by an `<mxCell>` element inside the `<root>`. An `<mxCell>` can represent either a **vertex** (a shape/node), an **edge** (a connector/arrow), or a **container** (group or swimlane). The role of the cell is indicated by attributes like `vertex="1"` for shapes and `edge="1"` for connectors. Key attributes of `mxCell` include:

- **id:** A unique identifier for the cell within the diagram. Other cells (e.g., connectors) refer to this id in their `source` or `target` attributes. Ids are often autogenerated strings (or numbers).
- **value:** The text or label associated with the cell. If the cell has a visible label, `value` contains that text. This can include HTML content (escaped) if `html=1` style is enabled. For example, a multi-line or formatted label may appear as an HTML `<font>` tag string inside `value` (and will be stored with entities like `&lt;` for `<`). If a shape has no text, `value` may be an empty string or absent.
- **style:** A semicolon-separated list of style directives for the cell’s appearance/behavior. This string defines visual properties (shape type, colors, etc.) and is explained in detail in the next section. Example: `style="rounded=0;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;"`.
- **parent:** The id of this cell’s parent in the cell hierarchy. This is how grouping and layering are handled. For most top-level shapes, `parent="1"` (meaning the default layer). If the shape is inside a group or container, the parent will be the group’s id. Likewise, if a cell is part of a different layer, its parent is that layer’s id.
- **vertex:** If present and set to "1", it marks the cell as a vertex (i.e., a shape/node). Non-vertex cells either omit this or have `edge="1"` if they are connectors.
- **edge:** If present and "1", marks the cell as an edge (connector line). Edge cells will typically also have `source` and `target` attributes.
- **source, target:** For edge cells, these attributes specify the ids of the source vertex and target vertex that the connector runs between. For example, `source="Igma...-3"` and `target="Igma...-5"` link an edge to those vertex cells. If an edge is not connected at one or both ends, the source/target may be omitted or refer to temporary points.
- **connectable:** An optional attribute that can be "0" to mark a cell as non-connectable (meaning other connectors won’t snap to it). By default, most vertices are connectable. This is often set to "0" for container shapes (groups) or decorative element.
- **collapsed:** (Not shown in all examples, but possible) If a group or swimlane cell is collapsible, `collapsed="1"` indicates it is currently collapsed (children hidden); `"0"` or absence means expanded. This corresponds to foldable containers.
- **visible:** (Rarely used explicitly in .drawio XML) Could indicate a cell or layer visibility. Typically layers when hidden might not be stored as an attribute, but some implementations might use `visible="0"` on a layer cell to mark it hidden. In practice, the .drawio editor handles layer visibility without this flag, but the mxGraph model supports it.

An example below shows a few cells from a diagram’s XML: two vertex cells and one edge cell connecting them. Note that `id="0"` and `id="1"` (the root and layer) are present but omitted here for brevity – all other cells have parent "1" (the default layer) unless otherwise specified:

    <!-- A vertex (shape) cell -->
    <mxCell id="Igma...-1" value="" style="rounded=0;whiteSpace=wrap;html=1;
            fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
        <mxGeometry x="20" y="10" width="80" height="40" as="geometry"/>
    </mxCell>

    <!-- Another vertex cell -->
    <mxCell id="Igma...-3" value="" style="rounded=0;whiteSpace=wrap;html=1;
            fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
        <mxGeometry x="141" y="10" width="80" height="40" as="geometry"/>
    </mxCell>

    <!-- An edge (connector) cell connecting the above two vertices -->
    <mxCell id="Igma...-2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;
            orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.25;exitDx=0;
            exitDy=0;entryX=0;entryY=0.75;entryDx=0;entryDy=0;" edge="1" parent="1" 
            source="Igma...-1" target="Igma...-3">
        <mxGeometry relative="1" as="geometry"/>
    </mxCell>

In this snippet, the two `<mxCell>` with `vertex="1"` represent rectangle shapes (with no text value). The `<mxCell>` with `edge="1"` is a connector whose `source` and `target` refer to the two vertices’ ids. The edge’s style (explained later) specifies an orthogonal (elbow) connector with certain routing constraints. The `<mxGeometry>` for the edge has `relative="1"`, indicating it’s a relative geometry (more details in the Geometry section).

**Hierarchy and Grouping:** The parent-child relationships between mxCells allow for grouping of shapes. A **group** in draw.io is essentially a vertex that contains other vertices. To create a group, one cell is designated as the group container (often given a style of `group`). All cells that should be in the group will have their `parent` attribute set to the group’s id. The group container itself usually has `parent` equal to a layer or another group (where it resides), and often has `connectable="0"` so that connectors attach to the child shapes rather than the group outline. For example:

    <mxCell id="2" value="" style="group;rotatable=0;" vertex="1" connectable="0" parent="1">
        <mxGeometry width="190" height="130" as="geometry"/>
    </mxCell>
    <mxCell id="3" value="Notes" style="rounded=0;whiteSpace=wrap;html=1;shadow=1;
            strokeColor=#CCCCCC;fillColor=#999999;fontColor=#FFFFFF;align=left;
            spacingLeft=4;resizable=0;movable=0;editable=0;connectable=0;allowArrows=0;
            rotatable=0;" vertex="1" parent="2">
        <mxGeometry width="190" height="30" as="geometry"/>
    </mxCell>
    <mxCell id="4" value="" style="rounded=0;whiteSpace=wrap;html=1;shadow=1;
            strokeColor=#CCCCCC;align=left;verticalAlign=top;spacingLeft=4;
            movable=0;resizable=0;connectable=0;allowArrows=0;rotatable=0;" 
            vertex="1" parent="2">
        <mxGeometry y="30" width="190" height="100" as="geometry"/>
    </mxCell>

Here, `id="2"` is a group container (no label, style includes `group`) and has two child vertices: `id="3"` and `id="4"`, both with `parent="2"`. The group might represent a note object composed of a title (cell 3) and a body (cell 4). The child cells have `rotatable=0`, `movable=0`, etc., meaning they inherit some non-movable or fixed behavior as part of the group. The group cell (id 2) encloses them (with a geometry of 190×130). Visually, draw.io will draw a bounding box around the grouped children if the group itself has a visible shape style (here style is just `group;` which usually defaults to a transparent or minimal rectangle).

**Note:** By default, the first two cells (`id="0"` and `id="1"`) should not be modified or removed, as they are required by the mxGraph model. When adding new cells manually, do not duplicate these; they exist once per diagram. All new shapes should typically have a parent of either "1" (for the base layer) or another layer/group as appropriate.

## Style Attributes for Shapes and Connectors

Each cell’s `style` attribute defines its appearance and some behavioral properties. The style is a `key=value;key=value;...` string. Many style keys are supported by the mxGraph engine used in draw.io. Here we will cover common style attributes:

### Common Shape (Vertex) Style Keys

- **shape:** Specifies the basic shape type of the vertex. If not given, the default is "rectangle" (a rectangle shape). Common values include:
- `"rectangle"` (default box shape, can be with sharp or rounded corners depending on `rounded` key),
- `"ellipse"` (oval/circle shape),
- `"rhombus"` (diamond shape),
- `"triangle"` (triangle, often with an additional `direction` key to specify orientation, e.g., north, south, etc.),
- `"hexagon"`, `"cylinder"`, `"cloud"`, `"line"`, `"label"`, etc., and also library-specific shapes like `"mxgraph.flowchart.start_end"` or custom shapes.
- For image cells, use `shape="image"` (along with the `image` key, described below). For text labels without a shape, draw.io sometimes uses `shape="text"` or simply a text style (see Text styles).
- **rounded:** `"1"` to round the corners of a rectangle or to round the bends of an edge. `"0"` for sharp corners (default 0). For connectors, `rounded=1` makes the elbow or curves rounded.
- **fillColor:** Fill color of the shape in hex (e.g., `#FF0000` for red). Use `fillColor="none"` for no fill (transparent interior).
- **gradientColor:** A secondary color for a gradient fill. If set, the shape’s fill will transition from `fillColor` to `gradientColor`. If `gradientColor` is `none` or not set, no gradient is applied.
- **gradientDirection:** The direction of the gradient if used. Can be `"north"`, `"south"`, `"east"`, `"west"`. For example, `"west"` means the gradient goes left-to-right.
- **strokeColor:** Outline (border) color of the shape (hex or 'none'). For no border, use `strokeColor="none"`.
- **strokeWidth:** Width of the shape’s outline in pixels (e.g., `strokeWidth=2` for a 2px border). Default is 1.
- **dashed:** `"1"` to make the outline (or connector) dashed instead of solid. By default dashed lines use a preset pattern; you can further customize with `dashPattern`.
- **dashPattern:** If `dashed=1`, this defines the dash pattern as space-separated lengths. For example, `dashPattern="5 5"` would mean 5px dash, 5px gap.
- **opacity:** Overall opacity (0-100) of the shape and its border.
- **shadow:** `"1"` to display a shadow under the shape, `"0"` for no shadow.
- **glass:** `"1"` adds a glass-like overlay effect (applicable to certain shapes, e.g., to give a glossy top shine).
- **perimeter:** Defines the perimeter type for connection points. By default, the connector anchor is the shape’s outline. You can set a different perimeter function, e.g., `perimeter="ellipsePerimeter"` or `perimeter="rectanglePerimeter"`, etc., which are built-in functions that determine how connectors attach.
- **perimeterSpacing:** Extra spacing (pixels) to keep connectors away from the shape outline. There are also `sourcePerimeterSpacing` and `targetPerimeterSpacing` for per-connector end spacing.
- **rotation:** Numeric rotation angle of the shape in degrees (0, 90, 180, etc., or any angle).
- **horizontal:** Used mainly for swimlanes or certain shapes to indicate orientation. `"0"` or `"1"` (for example, a swimlane with `horizontal="0"` might flip orientation of the lane).
- **whiteSpace:** Controls text wrapping. Typically set to `"wrap"` to enable word-wrap for the cell’s label. If set to `"nowrap"` or left blank, text will not wrap within the shape.
- **overflow:** Determines how text overflow is handled. Values: `"visible"` (text can overflow the shape bounds), `"hidden"` (clipped), `"fill"` (resize shape to fit text), etc.
- **resizable:** `"0"` to prevent the shape from being resized by the user. `"1"` or default allows resizing.
- **rotatable:** `"0"` to lock rotation (disallow manual rotation), otherwise shapes are rotatable by default.
- **deletable, movable, editable:** Similar boolean flags (`=0` to disallow) for deleting the shape, moving it, or editing its label via the UI.
- **connectable:** `"0"` to disallow attaching connectors to this shape. By default most shapes are connectable unless style or cell property disables it.

### Edge (Connector) Style Keys

Connectors (edges) have their own style properties controlling routing and arrowheads:

- **edgeStyle:** Determines the routing style of the connector. Common values:
- `"orthogonalEdgeStyle"` – an orthogonal (right-angled) connector that routes with horizontal/vertical segments.
- `"straight"` or `"straightEdgeStyle"` – a straight line connector.
- `"elbowEdgeStyle"` – an elbow connector (with one bend by default).
- `"entityRelationEdgeStyle"` – specialized style for entity-relationship diagrams (similar to orthogonal with certain behavior).
- `"segmentEdgeStyle"` – a polyline with a fixed segment length.
- `"curvedEdgeStyle"` – a curved connector (can also use `curved=1` in some cases).
- **curved:** An alternative to using `"curvedEdgeStyle"`. Setting `curved="1"` on an edge with orthogonal style will make its segments curved instead of sharp angles.
- **rounded:** As with shapes, if `rounded=1` on an edge, the corners of polyline segments will be rounded (arc) instead of sharp.
- **jettySize:** Used with orthogonal edges, defines the size of jetty (offset) at terminals. Often set to `"auto"` to automatically route connectors with some offset.
- **orthogonalLoop:** For a self-looping connector (edge that starts and ends on the same vertex), `orthogonalLoop=1` will route it as a loop with orthogonal segments.
- **entryX, entryY / exitX, exitY:** Define the relative connection point on the source or target vertex’s perimeter. These are given as ratios from 0 to 1 (as a percentage of width/height). For example, `exitX=1; exitY=0.25` means the connector leaves the source shape at 100% of its width (right edge) and 25% of its height from the top. Similarly, `entryX=0; entryY=0.75` means it enters the target at the left edge, 75% from the top. These are often generated when connectors attach to specific perimeter points.
- **entryDx, entryDy / exitDx, exitDy:** These can provide an absolute pixel offset for the entry/exit point if needed (often 0 if not used).
- **startArrow, endArrow:** Define the arrowhead marker at the start or end of the line. Values include common arrow shapes like `"classic"` (a classic arrowhead), `"block"`, `"open"`, `"oval"`, `"diamond"`, `"none"`, etc. For example, `endArrow="classic"` will put a classic filled arrow at the target end. To have no arrow, use `"none"`.
- **startFill, endFill:** `"1"` or `"0"` to indicate whether the arrowhead at start or end should be filled (solid) or open (hollow). Usually, `startFill=1` (fill the arrow) for arrows like classic, while for something like an open arrow you might use `endFill=0`.
- **startSize, endSize:** The size (length) of the arrow markers. For example, `endSize="12"` to make a larger arrowhead.
- **dashed, strokeColor, strokeWidth:** These affect the connector line similar to shape outlines. A connector uses `strokeColor` for line color and `strokeWidth` for thickness. If `dashed=1`, the connector line is dashed.
- **jumpStyle, jumpSize:** For connectors crossing each other (if configured), `jumpStyle` can be `"arc"` or `"gap"` to draw a bridge or gap at intersections. `jumpSize` sets the size of the jump effect.
- **labelBackgroundColor, labelBorderColor:** Background fill color or border color for the connector’s label text, if you want the text on a connector to have a highlight or border.
- **align** (for edges): When used on edges, `align` can control label alignment relative to the line (e.g., left/center/right alignment along the curve). In many cases, connector labels are centered by default.
- **segment:** (Used for `segmentEdgeStyle` or elbows) This numeric value defines the length of the horizontal segment in an elbow or the distance of label for segment connectors.

### Text and Label Style Keys

These styles control how text labels are rendered on shapes or connectors:

- **fontColor:** Color of the label text (hex code). Default is often black.
- **fontSize:** Size of the text in points.
- **fontFamily:** Name of the font (e.g., `"Helvetica"` or `"Arial"`).
- **fontStyle:** A numeric bitmask for bold/italic/underline. In mxGraph, 1=bold, 2=italic, 4=underline (so a value of 3 would be bold+italic, etc.).
- **align:** Horizontal alignment of the label within the shape. Can be `"left"`, `"center"`, or `"right"`. For vertices, this aligns text within the shape’s bounds. For edges, this might align multi-line text relative to a reference point.
- **verticalAlign:** Vertical alignment of the label. `"top"`, `"middle"`, `"bottom"`. For vertices, this aligns text within the shape vertically.
- **labelPosition** and **verticalLabelPosition:** These keys control the position of the label relative to the shape. For example, `verticalLabelPosition="bottom"` with `verticalAlign="top"` can push the label to appear just outside below a shape. Similarly, `labelPosition="left"` with `align="right"` would position the label to the left of the shape. These are often used for shapes that act as containers or icons where the label is placed outside.
- **spacing, spacingLeft, spacingRight, spacingTop, spacingBottom:** Padding between the text and the shape’s borders (in pixels). For instance, `spacingLeft=4` adds 4px padding on the left side before text begins. This ensures text isn’t flush against the shape edges.
- **labelWidth:** If set (in pixels), the text label will be wrapped to this width instead of the shape’s width. Useful if you want a fixed text width.
- **textOpacity:** Separate opacity for the text (0-100) if you want the text to fade relative to shape.
- **overflow:** (Mentioned earlier) set to `"width"` or `"fill"` to allow text to overflow shape width or to auto-resize shape. `"clip"` to clip overflow, `"visible"` to allow it to draw outside.
- **noLabel:** If set to `"1"`, the shape’s label is hidden entirely (used when a shape has no meaningful label and you want to suppress any text rendering).

**HTML Labels:** When the style `html=1` is present (common default in draw.io), the label text is interpreted as HTML, allowing basic formatting (font tags, bold, line breaks, etc.). In the XML, any HTML markup in the `value` will be escaped (e.g., `<br>` stored as `&lt;br&gt;`). If `html=0`, the label is treated as plain text (no formatting other than line breaks).

For example, a style for a text label shape might look like:

    style="text;html=1;align=center;verticalAlign=middle;fontSize=14;fontColor=#000000;"

Using `shape=text` or `style="text;..."` indicates a stand-alone label with no bounding box (often the case when you insert a text element in draw.io). The `text` shape typically implies no fill or stroke and just renders the label. Many of the above keys (spacing, etc.) may not apply to pure text shapes.

In practice, you can inspect a shape’s style by selecting a shape in diagrams.net and choosing **Edit \> Style** – it will show all the key:value pairs for that shape’s current style. The style format is consistent with what appears in the XML.

## Geometry and Positioning (`<mxGeometry>`)

Each mxCell (except possibly placeholders like id="0") contains an `<mxGeometry>` child element that defines the cell’s position and size (for vertices) or defines connector points (for edges). The `<mxGeometry>` always has an attribute `as="geometry"` and may include the following attributes:

- **x, y:** The x and y position of the cell’s upper-left corner. For vertices, these are the coordinates within the parent coordinate space. For top-level shapes, (x,y) are coordinates on the diagram canvas. For a shape inside a group, (x,y) are relative to the group’s origin. If an edge has an `mxGeometry` with an `x` and `y`, those might be used for edge label positioning or might be present for edges that have a fixed label position.
- **width, height:** The size of the cell (for vertices). For example, `width="120" height="60"` defines a rectangle 120px wide and 60px tall. For edges, `width` and `height` may be omitted or used to define an approximate bounding box for loops.
- **relative:** A boolean (0 or 1, though often treated as true/false) indicating if the geometry is relative to something:
- For edges, `relative="1"` means the geometry is relative to source/target (the edge path is calculated dynamically). Essentially all connector `mxGeometry` will have `relative="1"`.
- For vertices, `relative="1"` is used in special cases, e.g., for a child vertex that should be positioned relative to the parent’s width/height (like a percentage). In normal absolute positioning of child shapes, `relative` is `"0"` (default, often omitted). One case where a vertex might use `relative="1"` is if it’s used as a label for an edge or for anchoring – for example, the **label** of an edge can be an `mxCell` with `vertex="1"` and `parent` = edge id, and its geometry might be `relative="1"` with `x` and `y` representing relative positioning along the edge.
- **as="geometry":** This attribute is always set to identify the element’s purpose.

For connectors, the `<mxGeometry>` often contains child `<mxPoint>` elements defining waypoints or custom endpoints: - `<mxPoint as="sourcePoint" x="..." y="..."/>` specifies an absolute position where the edge leaves the source vertex. This might appear if the connector’s start is not exactly at the source shape’s perimeter (for example, if manually repositioned). - `<mxPoint as="targetPoint" x="..." y="..."/>` similarly specifies where the edge meets the target vertex. - Unnamed `<mxPoint>` elements (without an `as` attribute or with `as="point"`) inside `<mxGeometry>` define intermediate waypoints for the connector’s path. They are listed in order for the edge to pass through those coordinates. - `<mxPoint as="offset" x="..." y="..."/>` can appear in a vertex label’s geometry (if the label is separate) to specify an offset for the label position relative to the vertex center. In the example in the Google Groups thread, an edge’s label used an offset point.

For example, consider a self-loop edge (an edge from a shape back to itself) which might store its control points and start/end points. It could look like:

    <mxCell id="5" style="endArrow=classic;html=1;entryX=0;entryY=0.25;exitX=1;exitY=0.75;" 
            edge="1" parent="1" source="2" target="2">
        <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="21" y="118" as="sourcePoint"/>
            <mxPoint x="71" y="68" as="targetPoint"/>
        </mxGeometry>
    </mxCell>

In this snippet, the edge (id="5") is a loop on cell "2". The geometry has a defined `width` and `height` (possibly the loop’s enclosing box), and two points marking where the loop leaves and re-enters the shape. The style keys `entryX, entryY, exitX, exitY` further refine the attach points on the shape (here specifying different perimeter points for exit vs entry). Intermediate waypoints, if any, would be additional `<mxPoint>` elements listed in sequence.

For a normal edge with no manual waypoints, typically you’ll see just `<mxGeometry relative="1" as="geometry"/>` (empty geometry) and the routing will be automatic based on `edgeStyle`.

For group or container vertices, the `<mxGeometry>` has the container’s size, and child vertices’ geometries are relative to the container’s origin (the container’s top-left). Draw.io does not use `relative="1"` for a child shape’s geometry; instead, it keeps them absolute to the parent’s coordinate space (so if a group is at (100,100) and child at (10,10), the child’s absolute position will ultimately be (110,110) on the page, but XML stores (10,10) with parent=group).

**No** `<mxGeometry>`**:** The only cells that might lack an `<mxGeometry>` are the special root cells id "0" and sometimes id "1". In all diagrams, id "0" is a dummy root with no geometry (it’s not a visual cell), and id "1" (layer) also doesn’t require geometry (since it’s just a layer grouping). All actual visible vertices and edges should have an `<mxGeometry>`.

## Diagram Metadata and Page Settings

The `<mxfile>` element at the top can include metadata about the file and editing environment: 
- **modified:** A timestamp of last modification (in ISO 8601 format, UTC). 
- **host:** The host application or domain. For example `"app.diagrams.net"` if edited on the web app, or `"Electron"` if using the desktop app, or empty. 
- **agent:** The user agent or environment string for the editor (often includes browser and OS info). 
- **version:** The version of diagrams.net/draw.io that saved the file (e.g., "14.6.13"). This helps track compatibility. 
- **etag:** A unique hash or checksum of the diagram state at save time. This is used internally (for example, to detect conflicts or cached versions). It’s a string like `"jyk4LjRpkp5MiVdB0UgM"`. It can be ignored when hand-writing an XML (the application will generate a new one if needed). 
- **type:** The platform or export type. Common values: `"device"` (if saved from a device or desktop), `"google"` (if saved in Google Drive), etc. This is informational; for a valid file, `"device"` is safe to use. 
- **compressed:** This attribute may appear in newer versions of draw.io to explicitly flag whether the `<diagram>` content is stored compressed. If `compressed="false"`, the diagram XML is plain (readable) inside `<diagram>`; if `true`, the content is compressed (and thus not directly readable). By default, if not present, the application assumes compressed content (since modern draw.io saves diagrams compressed by default). Setting `compressed="false"` in the `<mxfile>` ensures the file is saved uncompressed next time.

An example of the top-level `<mxfile>` with the compressed flag:

    <mxfile compressed="false" host="Electron" modified="2020-08-13T04:03:47.601Z" 
            agent="..." etag="kCKDMwt64oLDwPazfI5o" version="13.6.2" type="device">
        <diagram id="...-sphuG..." name="Page-1">
            <!-- uncompressed diagram content here: <mxGraphModel> ... </mxGraphModel> -->
        </diagram>
    </mxfile>

And if it were compressed:

    <mxfile compressed="true" ...>
        <diagram id="...-sphuG..." name="Page-1">...Base64+deflated content...</diagram>
    </mxfile>



When manually writing a .drawio file from scratch, you would typically set `compressed="false"` so you can directly include the `<mxGraphModel>` XML. The `modified`, `etag`, and `id` values can be any valid identifiers or timestamps; they are not strictly validated by the parser, but using a proper timestamp and a unique id string for the diagram is good practice.

**Diagram Name:** The `<diagram name="...">` attribute is what appears as the tab name in the editor for multi-page files. You can set this to any user-friendly name. It’s stored as plain text (if special characters are needed, ensure proper XML escaping).

**Page Size vs. Diagram Extents:** If `page="1"`, the `pageWidth` and `pageHeight` define the page size. The content might extend beyond this; the editor will show a page boundary. If `page="0"`, the canvas is infinite and `pageWidth/Height` may be ignored (or set equal to diagram extents). The `dx` and `dy` attributes in `<mxGraphModel>` might reflect the current diagram content area, which can be different from page size. For example, `pageWidth="1100" pageHeight="850"` might be an A4 or letter size page, whereas `dx`/`dy` could be smaller if the drawing only occupies a portion.

**Background:** As shown in the example, `background="#ffffff"` sets the page background color. If omitted, white is default. You can change it to any color code or "none" for transparent (though "none" might be interpreted as default white by some clients).

**Grid and Guides:** The grid, guides, and other booleans in `<mxGraphModel>` are more editor preferences. They won’t affect the diagram’s content or how it renders in an export, but they will set whether the grid is shown when editing, etc. If writing from scratch, you can set `grid="1" gridSize="10" guides="1"` to enable those helpful editing features by default.

## Example: A Simple Diagram XML

Putting it all together, here’s a simplified example of a complete .drawio diagram XML (uncompressed). This diagram contains one page with two shapes and a connector between them:

    <?xml version="1.0" encoding="UTF-8"?>
    <mxfile compressed="false" host="app.diagrams.net" modified="2025-01-18T02:00:00.000Z" 
            agent="Mozilla/5.0 (Macintosh; Intel Mac OS X)" version="15.8.7" type="device">
      <diagram id="example-diagram-1" name="Page-1">
        <mxGraphModel dx="500" dy="400" grid="1" gridSize="10" guides="1"
                      tooltips="1" connect="1" arrows="1" fold="1" page="1"
                      pageScale="1" pageWidth="800" pageHeight="600" background="#ffffff"
                      math="0" shadow="0">
          <root>
            <mxCell id="0"/>
            <mxCell id="1" parent="0"/>
            <!-- Shape 1: Rectangle -->
            <mxCell id="2" value="Hello" style="whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
              <mxGeometry x="100" y="100" width="120" height="60" as="geometry"/>
            </mxCell>
            <!-- Shape 2: Ellipse -->
            <mxCell id="3" value="World" style="shape=ellipse;whiteSpace=wrap;html=1;fillColor=#ffdcdc;strokeColor=#d65555;" vertex="1" parent="1">
              <mxGeometry x="300" y="150" width="80" height="80" as="geometry"/>
            </mxCell>
            <!-- Connector from Shape 1 to Shape 2 -->
            <mxCell id="4" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;endArrow=classic;strokeColor=#6c8ebf;" edge="1" parent="1" source="2" target="3">
              <mxGeometry relative="1" as="geometry"/>
            </mxCell>
          </root>
        </mxGraphModel>
      </diagram>
    </mxfile>

This example is illustrative: it sets up a page 800×600 with a grid, places two shapes (a rectangle and a circle) and connects them with an orthogonal elbow arrow. One can copy such XML into draw.io (Extras \> Edit Diagram \> paste) to see the result.

## Compression and Encoding Conventions

By default, draw.io compresses the XML content of diagrams to reduce file size. The content inside each `<diagram>` tag (between the tags) is typically a Base64-encoded, deflated string. When you open a .drawio file, the application will decode this to get the XML. If you are writing a .drawio file by hand, you have two choices: 1. Save it uncompressed (set `compressed="false"` in `<mxfile>` and put the `<mxGraphModel>` XML directly inside `<diagram>`). 2. Save it compressed (set `compressed="true"` and provide a compressed Base64 string inside `<diagram>`).

For manual editing and clarity, **uncompressed XML is recommended**, since it’s human-readable. If you choose to compress it, you must follow the exact steps draw.io uses for encoding. The process for compression is:

- **Deflate (zlib compress)** the UTF-8 XML string of `<mxGraphModel>...</mxGraphModel>`.
- **Base64 encode** the compressed binary.
- **URL encode** the Base64 string (draw.io uses a URL-safe variant). This means that certain characters may be percent-encoded. In practice, the draw.io compressor might produce a string with `+`, `/`, `=`, which are then replaced or encoded for safe inclusion in an XML attribute or URL.

To decode a compressed diagram manually, reverse these steps: Base64 decode -\> Inflate (decompress) -\> URL decode. There is an official online tool provided by JGraph (creators of draw.io) that performs this conversion. Also, the **Extras \> Edit Diagram** function in draw.io will show you the decompressed XML of the current diagram.

**Example:** In a `.drawio` file, you might see:

    <diagram id="SGW9pF4..." name="Page-1">zVbfb5swEP5reOwUMBD2uKZZW2mbKmXSur05+ALe... (base64 string) ...</diagram>

This gibberish is the compressed data. Once decoded with the steps above, it yields the `<mxGraphModel>` XML (as shown in earlier sections). If you open the file in the draw.io editor and disable compression (via File \> Properties \> untick "Compressed"), the file will be saved with a readable XML structure instead.

**Encoding Special Characters:** If you are embedding the XML in a context like an attribute or JSON (for example, custom libraries discussed below), additional escaping is needed. Within a normal .drawio XML file, the text is already in XML so characters like `<`, `>` in labels are escaped as `&lt;` `&gt;` automatically. Quotes inside attribute values are also escaped with `&quot;` or by backslashes if within JSON strings. If producing a plain .drawio (which is XML), you just follow XML escaping rules for any text in attributes or element content.

## Additional Features and Considerations

### Images and Media Embedding

Draw.io allows shapes that display images. To create an image shape in the XML, you set the style `shape=image` and provide an `image` attribute in the style pointing to the image source. For example:

    <mxCell id="6" value="" style="shape=image;verticalLabelPosition=bottom;verticalAlign=top;
            aspect=fixed;imageAspect=0;image=data:image/png;base64,iVBORw0KG...;" vertex="1" parent="1">
      <mxGeometry x="50" y="50" width="100" height="100" as="geometry"/>
    </mxCell>

In this style: 
- `shape=image` tells the renderer this cell is an image box. 
- `image=` provides the URL or data URI of the image. In this case, it’s a PNG image embedded as Base64 data (after the `data:image/png;base64,` prefix). You could also use an external URL (e.g., `image=https://example.com/pic.png`), but embedding as data ensures the image is contained in the file. 
- `aspect=fixed` along with `imageAspect=0` ensures the image’s aspect ratio is preserved when resizing. `aspect="fixed"` is typically used so that when the shape is resized, the image scales uniformly. `imageAspect=0` is an internal flag (0 or 1) indicating how to treat aspect; generally with `aspect=fixed`, the image will maintain its ratio. 
- `verticalLabelPosition=bottom; verticalAlign=top` in the style (as included above) means if there’s a text value, it will be positioned below the image (commonly, images can have a caption). In the example above, `value=""` (empty), so no label is shown, but those style keys are typically present by default. 
- Often for images, `resizable=0` and `aspect=fixed` are used together to prevent skewing the image. If you want an image shape to not allow changing its aspect, you can include `resizable=0;` (or simply rely on aspect fixed). 
- If using SVG images, the `image` attribute might be `data:image/svg+xml,<svg ...>` with the SVG XML inline or base64-encoded. Ensure any embedded SVG is properly URI-encoded if placed directly (spaces, quotes, etc. must be escaped or base64 encoded).

**Note:** Large embedded images will increase the .drawio file size accordingly. There’s no separate `<image>` tag in the XML; images are always handled via style and value (unless using the more complex \<mxfile\> with embedded PNG, which is a separate mode for PNG with XML, not typical for .drawio files). The geometry of the image cell defines the displayed size of the image.

### Grouping and Containers

As discussed, grouping is achieved by hierarchical placement of cells. There is no special XML tag for a group; any vertex can act as a container if other cells use it as parent. However, draw.io typically marks groups with the style `group` to indicate a non-rendered container or to give it minimal styling. Groups can also have a visible shape (you can group and still assign a shape style to the group cell). In the earlier example, `id="2"` had `style="group;..."` which by default results in a transparent rectangle. If you wanted the group to have, say, a dashed border, you could add `strokeColor=#000000;dashed=1;` to the group’s style.

**Swimlanes:** Swimlanes are a special type of container shape (often used for flowchart lanes). In XML, a swimlane is just a vertex with `shape=swimlane` style. It typically has a child `<mxCell>` for the lane’s title label (the title is actually a separate cell inside the swimlane group). The swimlane’s style often includes `startSize` to define the header area thickness, and possibly `horizontal=0` if vertical orientation. For example, a horizontal swimlane might have:

    <mxCell id="10" value="Lane A" style="shape=swimlane;startSize=30;horizontal=0;fillColor=#f0f0f0;..." vertex="1" parent="1">
        <mxGeometry x="0" y="0" width="400" height="200" as="geometry"/>
    </mxCell>

And within it, draw.io might automatically manage child cells for content. The swimlane’s `value` is the lane title text. The `startSize=30` reserves 30 pixels for the title bar. If `horizontal=0`, the title bar is vertical on the left; if `horizontal=1` (default), the title bar is at the top.

### Custom Properties (Data) and the `<object>` Tag

Draw.io allows attaching custom data (name/value pairs) to shapes and connectors via the **Edit Data** interface. In the XML, when a cell has custom properties or needs to store a complex user object, the representation switches from a lone `<mxCell>` to an `<object>` element wrapping the `<mxCell>`.

**What changes in XML when using custom data?** Essentially: 
- The `<object>` element is used in place of `<mxCell>` at the top level for that shape/connector. 
- The `<object>` carries the usual cell **id** (and *acts* like the cell for references) and includes attributes for any custom data fields as well as possibly a `label` attribute for the text label. 
- Inside the `<object>`, there is an `<mxCell>` which contains the style, geometry, and other standard attributes (like `vertex="1"` or `edge="1"`, `parent`, `source`, `target`).

For example, suppose we have a server shape with some custom data attributes "Zone", "Attribute", "CRUDE". The XML might be:

    <object label="DB Server" Zone="3" Attribute="BLAH.BLAH.BLAH" CRUDE="" id="3">
      <mxCell style="shape=cylinder;whiteSpace=wrap;html=1;strokeWidth=1;" vertex="1" parent="1">
        <mxGeometry x="240" y="890" width="60" height="80" as="geometry"/>
      </mxCell>
    </object>

Here: 
- The outer `<object>` has `id="3"` (this is the id used by other cells if they connect to this shape). - `label="DB Server"` serves the role of the cell’s value/text (instead of using `value` on mxCell). The draw.io editor will display "DB Server" as this shape’s text. 
- `Zone="3" Attribute="BLAH.BLAH.BLAH" CRUDE=""` are custom data attributes stored with this object. These might correspond to user-defined data fields. 
- Inside, the `<mxCell>` has the style and indicates it’s a vertex with parent 1 (on the main layer). Notice the `<mxCell>` does *not* have its own id – the id is on the object, and that is the identifier used for the shape. 
- The geometry is inside as usual.

For connectors with custom data, a similar structure is used. The Google Groups discussion showed that when data was added to connectors, an object was created to wrap the connector’s mxCell. Often, for edges, draw.io will actually split the connector into two parts: one `<object>` for the edge itself (with data on it) containing the edge’s mxCell, and another `<mxCell>` for the edge’s text label (since connectors can have separate label cells). In the example: 
- An `<object id="9" label="" Zone="" Attribute="" CRUDE="RU">` contains the edge’s mxCell (with edge="1", source, target, geometry, etc.). 
- Following that, there is a separate `<mxCell id="16" value="user-to-WebServer" style="text;...;labelBackgroundColor=#ffffff;" vertex="1" connectable="0" parent="9">...</mxCell>` which is the label on that edge, as a child of the edge’s object (parent="9").

The key takeaway: **If you are hand-writing XML and want to include custom data fields, wrap the cell in an** `<object>` **tag.** Add a `label` attribute (for the text value) and any custom attributes you need on the `<object>`. Then nest the `<mxCell>` inside. The `id` should be on the `<object>` (and that’s what you’ll use for parent, source, target references elsewhere). The inner mxCell typically has no id attribute in this case (the system assumes the object’s id). This inversion of order (object outside, cell inside) is done for easier backend parsing of user objects – essentially it keeps the custom data at the top level of the cell’s representation.

If you do not need custom data, you can just use `<mxCell>` by itself (which is simpler). Draw.io’s XML remains backward compatible – older versions used to sometimes have user object inside mxCell; newer ones invert it as above, but they will still load the old format. When creating new diagrams manually, it’s best to follow the current convention (object outside).

### Custom Shape Libraries (`<mxlibrary>` format)

While not part of a standard .drawio diagram file, it’s worth noting how the XML format can also describe shape libraries. A **custom library file** in draw.io is essentially a container for one or more shapes (or templates), often saved with a `.xml` extension (or `.drawio` if you choose). The structure is slightly different: instead of `<mxfile>`, it uses an `<mxlibrary>` root, containing a JSON array of library entries.

Each entry in the JSON array has properties like `"xml"` (the shape’s XML), `"w"`, `"h"` (the dimensions of the shape’s default size), `"title"` (name shown in the library palette), etc.. For example, a very simple library with one shape might look like:

    <mxlibrary>[{
      "xml": "<mxGraphModel><root><mxCell id=\"0\"/><mxCell id=\"1\" parent=\"0\"/>"
           + "<mxCell id=\"2\" value=\"Test3\" style=\"whiteSpace=wrap;html=1;fillColor=#ffffff;strokeColor=#000000;\" vertex=\"1\" parent=\"1\">"
           + "<mxGeometry width=\"120\" height=\"60\" as=\"geometry\"/></mxCell></root></mxGraphModel>",
      "w": 120,
      "h": 60,
      "title": "Test Shape"
    }]</mxlibrary>

*(Line breaks added for readability)*

Inside `<mxlibrary>...</mxlibrary>`, the content is a JSON string (notice the quotes and braces). The `"xml"` value is an escaped string of an `<mxGraphModel>` (like a mini-drawio diagram) describing the shape. In the above, you can see `id="0"`, `id="1"`, then a cell id "2" with some style. All the `<` and `>` are escaped (`&lt;` `&gt;`), and quotes inside the XML are backslash-escaped because they are within a JSON string. The library JSON format requires this kind of escaping if the XML is stored as plain text. By default, draw.io exports library files with the XML uncompressed but properly escaped. You can compress the XML in libraries too (using the same deflate+Base64 technique) and then it would be a shorter string with mostly alphanumeric + symbols.

The `"w"` and `"h"` in each entry specify the default width and height (in pixels) that the shape should have when dragged from the library. The `"title"` is the tooltip or name shown for that shape in the library palette. There can also be entries with `"data"` instead of `"xml"` for images (where `"data"` might have a data URI for an image).

**Important:** If writing a custom library XML by hand, remember that the content inside `<mxlibrary>` must form a valid JSON array. Often it’s easiest to export one from draw.io and follow that structure. For multiple shapes, you’d have multiple `{ ... }` objects separated by commas inside the `[...]`.

For normal .drawio usage, you typically won’t use `<mxlibrary>` unless you intend to distribute a library of shapes. It’s a side capability of the file format to note.

### Tips for Hand-Writing .drawio XML

- Ensure every `mxCell` (or `object`) has a unique `id`. Typically use a simple numbering or a unique string. Draw.io often uses a GUID-like string for ids of new shapes (like "IQM8xkm7UoOLgGwT3--F-1"), but you can use simpler identifiers (e.g., "2", "3", "4"... or any unique alphanumeric). If you use numeric ids, avoid 0 and 1 (as they are taken by root and first layer). Also avoid duplicates – duplicates can cause undefined behavior or one shape not appearing.
- Maintain the required hierarchy: Always include the root (id 0) and default layer (id 1). All other cells should eventually trace back to id 0 via parent links. If something is not appearing, check that its parent chain goes up to 1 and then 0.
- Order of cells in XML can matter for layering (z-order). Cells listed later in the `<root>` are drawn on top of earlier ones if they overlap on the same layer. Also, if you have an edge whose source is defined later in the file, it will still work (the engine looks up ids as needed). However, it’s logical to define shapes before connectors referencing them.
- Use indentation and line breaks liberally when writing by hand – draw.io will ignore whitespace in most places (except within labels). This can help keep things readable. The editor’s "Edit Diagram" view will show pretty-printed XML by default.
- If you include special characters in text (like `& < >`), make sure they are properly escaped (`&amp;`, `&lt;`, `&gt;`). If including non-ASCII characters, ensure your file encoding is UTF-8 (the `<?xml ... encoding="UTF-8"?>` header is important).
- After writing your XML, you can test it by opening draw.io (the diagrams.net app or online) and using **File \> Open From \> Device** (or URL) to load it. If something is wrong, the app might show an error or render an empty diagram. You can also use the **Extras \> Edit Diagram** text view in draw.io to paste your XML directly to verify it.
- **Validation:** There is no publicly released XSD for the .drawio format. But since it’s based on mxGraph, many of the structures follow that schema. The application is forgiving about ordering of attributes and presence/absence of some optional attributes.

## Conclusion

The .drawio XML format, while extensive, is logical once you understand mxGraph’s structure. It describes diagrams in terms of a graph model (mxGraphModel) containing cells (mxCells) with styles and geometry. By using the guidelines above, one can manually construct a .drawio file: define the overall structure (`<mxfile>` with a diagram), include the `<mxGraphModel>` with required attributes, add a `<root>` with base cells 0 and 1, then add your shapes (vertices) and connectors (edges) with appropriate styles and geometries.

With careful attention to IDs, parent references, and style syntax, you can hand-write a valid .drawio diagram from scratch that diagrams.net will open and display correctly. This allows advanced use-cases like generating diagrams from code or fine-tuning XML by hand for precision.