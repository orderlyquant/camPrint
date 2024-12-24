// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//

#show: doc => camPrint(
$if(title)$
  title: [$title$],
$endif$
$if(shorttitle)$
  shorttitle: [$shorttitle$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(draft)$
  draft: $draft$,
$endif$
$if(distribution)$
  draft: $distribution$,
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(book-style)$
  book-style: $book-style$,
$endif$
$if(footer-content)$
  footer-content: $footer-content$,
$endif$
  doc,
)
