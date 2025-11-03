#import "@preview/fontawesome:0.6.0": *

/// #mail
///
/// - email (str): the email address of the author
/// -> (block): a block containing the email address
#let mail(email) = {
  text(size: 1.2em)[#raw(email)]
}

/// 
/// - name (str): the name of the author
/// -> (block): a block containing the name of the author
#let first_author(name) = {
  strong(name)
}

/// #author_list
///
/// - authors (list of tuples): a list of tuples containing names and emails
/// -> (block): a block containing the authors' information
#let author_list(authors, logo: none, width: 35%) = block[
  #table(
    inset: (0em, 0em), column-gutter: 1em, row-gutter: 0.75em, stroke: none, columns: (auto, 4fr), align: (left, left),
    ..authors.map((record) => (record.at(0), mail(record.at(1)))).flatten()
  )
  #if logo != none {
    place(right)[
      #figure(image(logo, width: width))
    ]
  }
  #v(1em)
]

/// #bold
///
/// - content (block): the content to be displayed in bold
/// -> (block): a block containing the bolded content
#let bold(content) = {
  text(weight: "bold")[#content]
}

#let styled-block(
  title, 
  content, 
  icon: "", 
  fill-color: rgb("#f5f5f4"),
  stroke-color: rgb("#78716c"),
  title-color: rgb("#292524"),
  title-size: 20pt
) = {
  block(
    width: 100%,
    inset: (x: 24pt, y: 18pt),
    fill: fill-color,
    radius: 8pt,
    stroke: (
      paint: stroke-color, 
      thickness: 1pt,
      dash: "solid"
    ),
    [
      #text(weight: "bold", size: title-size, fill: title-color)[#icon #title]
      #v(-12pt)
      #line(length: 100%, stroke: (paint: stroke-color, thickness: 1.5pt))
      #v(-10pt)
      #content
    ]
  )
}

/// Blocks
#let feature-block(title, content, icon: "") = {
  styled-block(
    title, 
    content, 
    icon: icon,
    fill-color: rgb("#f0fdfa"),      // soft cyan background
    stroke-color: rgb("#14b8a6"),     // vibrant teal border
    title-color: rgb("#115e59"),      // deep teal title
    title-size: 22pt
  )
}

#let note-block(title, content, icon: fa-info-circle() + " ") = {
  styled-block(
    title, 
    content, 
    icon: icon,
    fill-color: rgb("#eff6ff"),       // soft indigo background
    stroke-color: rgb("#6366f1"),      // indigo border
    title-color: rgb("#3730a3"),       // deep indigo title
  )
}

#let warning-block(title, content, icon: fa-exclamation-triangle() + " ") = {
  styled-block(
    title, 
    content, 
    icon: icon,
    fill-color: rgb("#fef9c3"),       // soft yellow background
    stroke-color: rgb("#eab308"),      // amber-yellow border
    title-color: rgb("#854d0e"),       // deep amber title
  )
}

/// Definition callout box
///
/// - title (str): heading for the box (default "Definizione")
/// - content (content): body content
#let definition-block(title, content, icon: fa-book() + " ") = {
  styled-block(
    title,
    content,
    icon: icon,
    fill-color: rgb("#fae8ff"),       // soft purple background
    stroke-color: rgb("#a855f7"),      // purple border
    title-color: rgb("#6b21a8"),       // deep purple title
  )
}

/// Example callout box
///
/// - title (str): heading for the box (default "Esempio")
/// - content (content): body content
#let example-block(title, content, icon: fa-lightbulb() + " ") = {
  styled-block(
    title,
    content,
    icon: icon,
    fill-color: rgb("#ecfccb"),       // soft lime background
    stroke-color: rgb("#84cc16"),      // lime border
    title-color: rgb("#3f6212"),       // deep lime title
  )
}

/// Concept/Important callout box
///
/// - title (str): heading for the box (default "Concetto chiave")
/// - content (content): body content
#let concept-block(title, content, icon: fa-star() + " ") = {
  styled-block(
    title,
    content,
    icon: icon,
    fill-color: rgb("#f5f5f4"),       // neutral stone background
    stroke-color: rgb("#78716c"),      // warm gray border
    title-color: rgb("#292524"),       // dark stone title
  )
}

/// Feature card for AI-assisted capabilities
///
/// - icon (content): FontAwesome icon
/// - title (str): Feature name
/// - description (str): Short description
/// - gradient-from (color): Start color for gradient (kept for compatibility but not used in flat design)
/// - gradient-to (color): End color for gradient (kept for compatibility but not used in flat design)
/// - stroke-color (color): Border color (kept for compatibility but not used in flat design)
/// - title-color (color): Title text color
#let feature-card(
  icon,
  title,
  description,
  gradient-from,
  gradient-to,
  stroke-color,
  title-color
) = {
  block(
    width: 100%,
    inset: 0.8em,
    fill: rgb("#f0fdfa"),           // soft cyan background - same as feature-block
    radius: 8pt,
    stroke: 1pt + rgb("#14b8a6"),   // teal border - matches primary color
    [
      #align(center)[
        #text(size: 1.8em, fill: rgb("#14b8a6"))[#icon]
        #v(0.15em)
        #text(size: 0.95em, weight: "bold", fill: rgb("#115e59"))[#title]
        #v(0.1em)
        #text(size: 0.75em, fill: rgb("#57534e"))[#description]
      ]
    ]
  )
}
