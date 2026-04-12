// =============================================================================
//  template.typ
//  University report template
// =============================================================================

// -----------------------------------------------------------------------------
//  Cover page
// -----------------------------------------------------------------------------
#let logo-cover  = image("assets/undav.png", width: 5cm)
#let logo-header = image("assets/undav.png", width: 1.5cm)

#let cover(
  titulo:  "Título del trabajo",
  materia: "Nombre de la materia",
  carrera: "Nombre de la carrera",
  autor:   "Nombre del autor",
  fecha:   datetime.today(),
) = {
  set page(header: none, footer: none)
  set align(center)

  logo-cover
  v(1cm)

  text(size: 16pt, weight: "bold")[#carrera]
  v(3cm)
  text(size: 20pt, style: "italic")[#smallcaps(materia)]
  v(3cm)
  text(size: 16pt, style: "italic")[#titulo]
  v(1fr)
  text(size: 14pt)[Autor: #autor]
  v(1cm)
  text(size: 14pt)[
    #fecha.display("[day]/[month]/[year]")
  ]
  v(1fr)

  pagebreak()
}

// -----------------------------------------------------------------------------
//  Main template — wraps the document body
// -----------------------------------------------------------------------------
#let report(
  titulo:  "Título del trabajo",
  materia: "Nombre de la materia",
  carrera: "Nombre de la carrera",
  autor:   "Nombre del autor",
  fecha:   datetime.today(),
  lang:    "es",
  body,
) = {

  // --- Page setup ---
  set page(
    paper:  "a4",
    margin: (top: 25mm, bottom: 25mm, left: 20mm, right: 20mm),

    header: context {
      // Skip header on the very first page (cover)
      if counter(page).get().first() > 1 {
        grid(
          columns: (auto, 1fr),
          gutter: 6pt,
          align: (left + horizon, right + horizon),
          logo-header,
          text(size: 8pt)[
            #smallcaps(titulo) \
            #smallcaps(materia)
          ],
        )
        v(-8pt)   // remove empty line between header and horizontal line
        line(length: 100%, stroke: 0.5pt)
      }
    },

    footer: context {
      if counter(page).get().first() > 1 {
        line(length: 100%, stroke: 0.5pt)
        v(-6pt)   // remove empty line between horizontal line and footer
        align(center,
        text(size: 8pt)[
          #smallcaps[Página #counter(page).display() de #counter(page).final().first()]
        ]
      )
    }
  },
)

// --- Typography ---
set text(lang: lang, size: 11pt)
set par(justify: true, leading: 0.65em)

// --- Headings ---
set heading(numbering: "1.1.")
show heading: it => {
  v(0.8em)
  it
  v(0.4em)
}

// --- Code blocks ---
show raw.where(block: true): it => {
  set text(size: 9pt)
  block(
    fill:   luma(245),
    radius: 4pt,
    inset:  10pt,
    width:  100%,
    it,
  )
}
show raw.where(block: false): it => {
  box(
    fill:   luma(245),
    radius: 2pt,
    inset:  (x: 3pt, y: 1pt),
    it,
  )
}

// --- Figures ---
set figure(gap: 0.8em)
show figure.caption: it => {
  text(size: 9pt, style: "italic")[
    #it.supplement #it.counter.display(it.numbering): #it.body
  ]
}

// --- Tables ---
set table(
  stroke:      0.5pt + luma(180),
  fill:        (_, y) => if y == 0 { luma(230) } else { none },
  inset:       6pt,
  align:       center + horizon,
)
show table.cell.where(y: 0): strong

// --- Links ---
show link: underline

// -------------------------------------------------------------------------
//  Document body
// -------------------------------------------------------------------------
cover(
  titulo:  titulo,
  materia: materia,
  carrera: carrera,
  autor:   autor,
  fecha:   fecha,
)

body
}
