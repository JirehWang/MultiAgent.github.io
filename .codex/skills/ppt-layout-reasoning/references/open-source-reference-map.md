# Open-source reference map

Use these projects as conceptual reading only. They are not dependencies of this skill, and their implementation assumptions do not replace the user's PowerPoint editing or generation workflow.

| Project | Source | Study for | Limit when applying the idea |
| --- | --- | --- | --- |
| [PPTist](https://github.com/pipipi-pikachu/PPTist) | Repository | Editor/layout data models, element position and size, alignment and distribution, grouping, locking, and layer order. | A browser editor's data model is not PowerPoint OOXML; do not assume its coordinate system or object behavior transfers directly. |
| [Slidev](https://github.com/slidevjs/slidev) | Repository | Reusable layouts, themes, whitespace, composition constraints, and layout-as-a-system thinking. | Markdown/web rendering is not native PowerPoint geometry or editability. |
| [Marpit](https://github.com/marp-team/marpit) | Repository | Theme variables, slide composition, whitespace, authoring directives, and predictable pagination. | A rendered Markdown deck is not a collection of native PowerPoint shapes. |
| [PptxGenJS](https://github.com/gitbrent/PptxGenJS) | Repository | Native shape, text, chart, connector, and geometry vocabulary plus PowerPoint object constraints. | Use the vocabulary conceptually; do not require its package or assume its API matches the user's tool. |
| [python-pptx](https://github.com/scanny/python-pptx) | Repository | Reading slide geometry, placeholders, shape types, and relationships when analyzing an existing deck. | It is an OOXML/Python API, not a full-fidelity visual layout engine and not a required install. |
| [PPTAgent](https://github.com/icip-cas/PPTAgent) | Repository | Reference-slide analysis, functional types, content schemas, reflection, rendering, and iteration loops. | Its agent/generation pipeline is a conceptual workflow reference, not a required runtime or editing path. |

## License boundary

Concepts and publicly described patterns are not a license to copy implementation. If code or assets are reused, inspect the source's current `LICENSE`, `NOTICE`, and file headers and preserve every applicable copyright, attribution, license-text, notice, and redistribution obligation. When terms are unclear, keep the work conceptual and do not copy.
