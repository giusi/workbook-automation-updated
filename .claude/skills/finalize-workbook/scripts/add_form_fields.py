#!/usr/bin/env python3
"""Add real AcroForm text-field widgets to a flat PDF at given coordinates.

Unlike stamping static text onto a page, this creates interactive form
fields a reader can tap/click and type into on both desktop and mobile PDF
viewers (Acrobat, Preview, Chrome/Edge built-in viewers, mobile Adobe
Reader). Requires pymupdf: `pip install pymupdf`.

Usage:
    python3 add_form_fields.py <input.pdf> <fields.json> <output.pdf>

fields.json shape:
[
  {
    "page": 6,                          # 1-indexed
    "field_name": "sez1_ex1_line1",     # unique across the whole document
    "rect": [72.0, 380.5, 520.0, 402.0],# [x0, y0, x1, y1] in PDF points,
                                         # y=0 at the BOTTOM of the page
    "font_size": 11                     # optional, default 11
  },
  ...
]
"""
import json
import sys

import pymupdf


def add_form_fields(input_path: str, fields_path: str, output_path: str) -> int:
    with open(fields_path, encoding="utf-8") as f:
        fields = json.load(f)

    doc = pymupdf.open(input_path)
    seen_names = set()

    for spec in fields:
        page_number = spec["page"]
        name = spec["field_name"]
        if name in seen_names:
            raise ValueError(f"duplicate field_name {name!r} — field names must be unique")
        seen_names.add(name)

        if not (1 <= page_number <= doc.page_count):
            raise ValueError(f"field {name!r} targets page {page_number}, "
                              f"document has {doc.page_count} pages")
        page = doc[page_number - 1]

        x0, y0, x1, y1 = spec["rect"]
        rect = pymupdf.Rect(x0, y0, x1, y1)
        if rect.is_empty or rect.width <= 0 or rect.height <= 0:
            raise ValueError(f"field {name!r} has a degenerate rect {spec['rect']}")

        widget = pymupdf.Widget()
        widget.field_name = name
        widget.field_type = pymupdf.PDF_WIDGET_TYPE_TEXT
        widget.rect = rect
        widget.text_font = "helv"
        widget.text_fontsize = spec.get("font_size", 11)
        widget.border_color = None
        widget.fill_color = None
        widget.field_value = ""
        page.add_widget(widget)

    # Belt-and-suspenders: ask viewers that don't render appearance streams
    # themselves (some older/mobile ones) to regenerate field appearances
    # on open, in addition to the appearance streams add_widget already sets.
    if doc.is_form_pdf:
        doc.need_appearances(True)

    doc.save(output_path)
    doc.close()
    return len(fields)


def main() -> None:
    if len(sys.argv) != 4:
        print(__doc__)
        sys.exit(1)
    input_path, fields_path, output_path = sys.argv[1:4]
    count = add_form_fields(input_path, fields_path, output_path)
    print(f"Added {count} form field(s). Wrote {output_path}")


if __name__ == "__main__":
    main()
