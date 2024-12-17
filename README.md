# cam-print Format

Quarto extension for a template to generate a PDF with nice styling using typst.
Use `cam-print-typst` for the format. Note that version 1.6 or greater of
quarto is required.


## Installation

To install the Quarto extension, create a directory, and use the template file:

``` bash
quarto use template cam-bos/cam-print
```

This will install the format extension and create an example qmd file
that you can use as a starting place for your document.

## Using

To use the extension in an existing project without installing the template file:

``` bash
quarto install extension cam-bos/cam-print
```
Note that you will need to update the output format to `format: cam-print-typst`
to enable use of the extension.

```{yaml}
---
title: Untitled
format:
  cam-print-typst: default
---
```