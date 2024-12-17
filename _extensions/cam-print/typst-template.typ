
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates
#import "@preview/drafting:0.2.0": *

#let wideblock(content) = block(width:100%+2.5in,content)

// Fonts used in front matter, sidenotes, bibliography, and captions
#let sans-fonts = (
  //"Gill Sans", 
  "Microsoft Sans Serif",
)

// Fonts used for headings and body copy
#let serif-fonts = (
  //"Cambria",
)

#let template(
  title: [Paper Title],
  shorttitle: none,
  subtitle: none,
  date: none,
  document-number: none,
  draft: false,
  distribution: none,
  abstract: none,
  publisher: none,
  toc: false,
  bib: none,
  footer-content: none,
  doc
) = {
  // Document metadata
  set document(title: title)

  // Just a suttle lightness to decrease the harsh contrast
  set text(fill:luma(30))

  // Tables and figures
  show figure: set figure.caption(separator: [.#h(0.5em)])
  show figure.caption: set align(left)
  show figure.caption: set text(font: sans-fonts)

  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set figure(numbering: "I")
  
  show figure.where(kind: image): set figure(supplement: [Figure], numbering: "1")
  
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [Code], numbering: "1")
  show raw: set text(font: "Lucida Console", size: 10pt)

  // Equations
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  show link: underline

  // Lists
  set enum(
    indent: 1em,
    body-indent: 1em,
  )
  show enum: set par(justify: false)
  set list(
    indent: 1em,
    body-indent: 1em,
  )
  show list: set par(justify: false)

  // Headings
  set heading(numbering: none,)
  show heading.where(level:1): it => {
    v(2em,weak:true)
    text(size:14pt, weight: "bold",it)
    v(1em,weak: true)
  }

  show heading.where(level:2): it => {
    v(1.3em, weak: true)
    text(size: 13pt, weight: "regular",style: "italic",it)
    v(1em,weak: true)
  }

  show heading.where(level:3): it => {
    v(1em,weak:true)
    text(size:11pt,style:"italic",weight:"thin",it)
    v(0.65em,weak:true)
  }

  show heading: it => {
    if it.level <= 3 {it} else {}
  }

  // Page setup
  set page(
    paper: "us-letter",
    margin: (
      left: 1in,
      right: 3.5in,
      top: 1.5in,
      bottom: 1.5in
    ),
    header: context {
      set text(font: sans-fonts)
      block(width: 100% + 3.5in - 1in,{
      if counter(page).get().first() > 1 {
        if document-number != none {document-number}
        h(1fr)
        if shorttitle != none {upper(shorttitle)} else {upper(title)}
        if publisher != none {
          linebreak()
          h(1fr)
          upper(publisher)
        }
      }})
    },
    footer: context {
      set text(font: sans-fonts,size: 8pt)
      block(width: 100% +3.5in - 1in,{
      if counter(page).get().first() == 1 {
        if type(footer-content) == array {
          footer-content.at(0)
          linebreak()
        } else {
          footer-content
          linebreak()
        }
        if draft [
          Draft document: #date
        ]
        if distribution != none [
          Distribution limited to #distribution.
        ]
      } else {
        if type(footer-content) == array {
          footer-content.at(1)
          linebreak()
        } else {
          footer-content
          linebreak()
        }
        if draft [
          Draft document: #date
        ]
        if distribution != none [
          Distribution limited to #distribution.
        ]
        linebreak()
        [Page #counter(page).display()]
      }
    })},
    background: if draft {rotate(45deg,text(font:sans-fonts,size:200pt, fill: rgb("EDEDF0"))[DRAFT])}
  )

  set par(
    // justify: true,
    leading: 0.65em,
    first-line-indent: 1em
  )
  show par: set block(
    spacing: 0.65em
  )

  // Frontmatter
  let titleblock(title: none,subtitle: none,) = wideblock({
      set text(
        hyphenate: false,
        size: 20pt,
        font: sans-fonts
      )
      set par(
        justify: false,
        leading:0.2em,
        first-line-indent: 0pt
      )
      upper(title)
      set text(size: 11pt)
      v(-0.65em)
      upper(subtitle)
    })
  let abstractblock(abstract) = wideblock({
      set text(font: sans-fonts)
      set par(hanging-indent: 3em)
      h(3em)
      abstract
    })
  // let tocblock() = wideblock({
  //    set text(font: sans-fonts)
  //    outline(indent:1em,title:none,depth:2)
  //  })

  titleblock(title:title, subtitle:subtitle)
  text(size:11pt,font: sans-fonts,{
    if date != none {upper(date)}
    // linebreak()
    // if document-number != none {document-number}
  })
  

  if abstract != none {abstractblock(abstract)}
  // if toc {tocblock()}

  // Finish setting up sidenotes
  set-page-properties()
  set-margin-note-defaults(
    stroke: none,
    side: right,
    margin-right: 2.35in,
    margin-left: 1.35in,
  )

  // Body text
  set text(
    font: serif-fonts,
    style: "normal",
    weight: "regular",
    hyphenate: true,
    size: 10.5pt
  )

  doc

}

/* Sidenotes
Display content in the right margin with the `note()` function.
Takes 2 optional keyword and 1 required argument:
  - `dy: length` Adjust the vertical position as required (default `0pt`).
  - `numbered: bool` Display a footnote-style number in text and in the note (default `true`).
  - `content: content` The content of the note.
*/
#let notecounter = counter("notecounter")
#let note(dy:-2em, numbered:true, content) = {
  if numbered {
    notecounter.step()
    text(weight:"bold",super(notecounter.display()))
  }
  text(size:8pt,font: sans-fonts,margin-note(if numbered {
    text(weight:"bold",font:"Lucida Bright",size:11pt,{
      super(notecounter.display())
      text(size: 8pt, " ")
    })
    content
  } else {
    content}
    ,dy:dy))
  }


// CAMPRINT

#let camPrint(
  title: none,
  date: none,
  shorttitle: none,
  subtitle: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  draft: false,
  doc,
) = {

  show: template.with(
    title: title,
    date: date,
    shorttitle: shorttitle,
    subtitle: subtitle,
    abstract: abstract,
    draft: draft
  )

  doc
  
}