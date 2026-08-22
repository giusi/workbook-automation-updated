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

    # Deliberately NOT setting NeedAppearances: add_widget already writes a
    # correct, self-contained appearance stream (with its own embedded font
    # resource) per field. Setting NeedAppearances=true instead tells viewers
    # to regenerate that appearance themselves — and strict renderers (Apple's
    # PDFKit, used by iOS Files/Quick Look/Mail) do that lookup via the
    # AcroForm's own /DR entry, not the field's local one. Without a top-level
    # /DR, that regeneration silently fails and the field never becomes
    # interactive: it renders fine but tapping does nothing. Acrobat and
    # PyMuPDF are lenient about this and mask the bug — iOS is not.
    #
    # Fix: leave NeedAppearances unset (the per-field appearances are already
    # correct) and add a top-level /DR + /DA to the AcroForm dict anyway, for
    # any stricter reader that expects the spec's canonical form-level
    # defaults to exist regardless of NeedAppearances.
    if doc.is_form_pdf and fields:
        first_widget = next(iter(doc[fields[0]["page"] - 1].widgets()))
        _, ap_ref = doc.xref_get_key(first_widget.xref, "AP")
        ap_n_xref = int(ap_ref.replace("<<", "").replace(">>", "")
                         .split("/N")[1].strip().split()[0])
        _, font_ref = doc.xref_get_key(ap_n_xref, "Resources")
        helv_xref = font_ref.split("/Helv")[1].strip().split()[0]

        # The AcroForm dict is stored inline on the catalog (not as its own
        # indirect object), so it has to be rewritten as a whole rather than
        # patched via a separate xref. Pull out the existing /Fields array
        # verbatim and rebuild the dict with /DR + /DA added and
        # /NeedAppearances dropped.
        catalog_xref = doc.pdf_catalog()
        _, acro_val = doc.xref_get_key(catalog_xref, "AcroForm")
        fields_start = acro_val.index("/Fields[") + len("/Fields[")
        fields_end = acro_val.index("]", fields_start)
        fields_list = acro_val[fields_start:fields_end]

        new_acroform = (
            f"<</Fields[{fields_list}]"
            f"/DR<</Font<</Helv {helv_xref} 0 R>>>>"
            f"/DA(0 0 0 rg /Helv 10 Tf)>>"
        )
        doc.xref_set_key(catalog_xref, "AcroForm", new_acroform)

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
