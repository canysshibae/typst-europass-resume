#let default-theme = (
  margin: 26pt,
  font: "URW Gothic",
  font-size: 8pt,
  font-secondary: "URW Gothic",
  font-tertiary: "URW Gothic",
  text-color: rgb("#3f454d"),
  gutter-size: 4em,
  main-height: 80%,
  top-height: 15%,
  profile-picture-width: 14%,
  name-font-size: 20pt,
)


#let resume(
  name: "",
  profession: "",
  bio: "",
  profile-picture: none,
  theme: (),
  aside: [],
  main,
) = {
  // Function to pick a key from the theme, or a default if not provided.
  let th(key, default: none) = {
    return if key in theme and theme.at(key) != none {
      theme.at(key)
    } else if default != none and default in theme and theme.at(default) != none {
      theme.at(default)
    } else if default != none {
      default-theme.at(default)
    } else {
      default-theme.at(key)
    }
  }

  // margins controlled by box containers
  set page(
    margin: 0pt,
  )

  // Fix for https://github.com/typst/typst/discussions/2919
  for lvl in (1,2,3,) {
    show heading.where(level: lvl): set text(size: th("font-size"))
  }

  show heading.where(level: 3): set text(font: th("font-tertiary"), weight: "light")

  set text(font: th("font"), size: th("font-size"), fill: th("text-color"))

  // Top.
  box(
    height: th("top-height"),
    fill: rgb("#f5f5f5"),
    box(
      width: 100% - th("margin"),
      {
        grid(
          rows: 3,
          columns: (th("profile-picture-width"), 1fr),
          column-gutter: 12pt,
          grid.cell(
            rowspan: 3,
            if profile-picture != none {
              set block(radius: 100%, clip: true, stroke: (black + 3pt))
              set align(horizon)
              set image(width: 100%)
              profile-picture
            }
          ),
          grid.cell(
            align: horizon + right,
            {          
            grid(
              columns: (75%, 25%),
              align: (right, left),
              gutter: 10pt,
              image(
              "images/Flag_of_Europe.svg",
              width: 35pt,
              ),
              text(size: 20pt, weight: "semibold", fill: rgb("#6c3087"), font: "URW Bookman")[europass]
            )
            }
          ),
          grid.cell(
            align: horizon + left,
            {
              text(size: 18pt, weight: "bold", font: th("font"), fill: th("text-color"), name)
              line(start: (0pt, -10pt), end: (100%, -10pt), stroke: 0.5pt)
            }
          ),
          grid.cell(
            align: horizon + center,
            {
            text(font: th("font-tertiary"), weight: "light", upper(profession))
            set text(weight: "light", style: "italic", hyphenate: true)
            set par(leading: 1.0em)
            // bio
            aside
            }
          )
        )
      }
    )
  )
  // Content.
  box(
    height: th("main-height"),
    main
  )
  
}


#let section(
  theme: (),
  title,
  body,
) = {
  show heading.where(level: 1): set align(theme.align-title) if "align-title" in theme
  show heading.where(level: 1): set align(end) if not "align-title" in theme

  if "space-above" not in theme {
    v(1fr)
  } else {
    v(theme.space-above)
  }


  heading(level: 1, upper(title))
  {
    set block(above: 2pt, below: 14pt)
    line(stroke: 1pt, length: 100%)
  }
  body
}

#let contact-entry(
  theme: (),
  gutter,
  right,
) = {
  set grid(rows: (theme.gutter-size, 1fr)) if "gutter-size" in theme
  set text(font: theme.font-secondary) if "font-secondary" in theme
  set text(font: default-theme.font-secondary) if "font-secondary" not in theme
  set text(size: theme.font-size) if "font-size" in theme

  grid(
    {
      context {
        set align(center) if not "align-gutter" in theme
        set align(theme.align-gutter) if "align-gutter" in theme
        gutter
      }
    },
    {
      right
    }
  )
}

#let language-entry(
  theme: (),
  language,
  level,
) = {
  set text(font: theme.font) if "font-secondary" in theme
  set text(font: default-theme.font-secondary) if "font-secondary" not in theme
  set text(size: theme.font-size) if "font-size" in theme

  stack(
    dir: ltr,
    language,
    {
      set align(end)
      level
    },
  )
}

#let work-entry(
  theme: (),
  timeframe: "",
  title: "",
  organization: "",
  location: "",
  body,
) = {
  set text(size: theme.font-size) if "font-size" in theme

  if "space-above" not in theme {
    v(1fr)
  } else {
    v(theme.space-above)
  }
  {
    set text(font: theme.font-secondary) if "font-secondary" in theme
    set text(font: default-theme.font-secondary) if "font-secondary" not in theme
    set block(above: 0pt, below: 0pt)
    stack(
      dir: ttb,
      spacing: 5pt,
      stack(
        dir: ltr,
        spacing: 1fr,
        context {
          set text(weight: "light", fill: text.fill.lighten(30%))
          timeframe
        },
        context {
          set align(horizon)
          set text(weight: "light", fill: text.fill.lighten(30%))
          location
        },
      ),
      {
        {
          set text(weight: "bold")
          upper(title)
        }
        " – "
        organization
      },
    )
  }
  {
    set block(above: 6pt, below: 8pt)
    line(stroke: 0.1pt, length: 100%)
  }
  context {
    set text(fill: text.fill.lighten(30%))
    set par(leading: 1em)
    body
  }
}

#let education-entry(
  theme: (),
  timeframe: "",
  title: "",
  institution: "",
  location: "",
  body,
) = {
  set text(size: theme.font-size) if "font-size" in theme

  {
    set text(font: theme.font-secondary) if "font-secondary" in theme
    set text(font: default-theme.font-secondary) if "font-secondary" not in theme
    stack(
      spacing: 5pt,
      {
        set text(weight: "bold")
        upper(title)
      },
      institution,
    )

    {
      set block(above: 6pt, below: 8pt)
      line(stroke: 0.1pt, length: 100%)
    }
  }


  context {
    set text(weight: "light", fill: text.fill.lighten(30%))
    stack(
      spacing: 8pt,
      {
        set text(font: theme.font) if "font" in theme
        body
      },
      {
        set text(font: theme.font-secondary) if "font-secondary" in theme
        set text(font: default-theme.font-secondary) if "font-secondary" not in theme
        timeframe
      },
    )
  }
}

#let github-icon = image("images/github-brands.svg", alt: "github icon")
#let phone-icon = image("images/phone-solid.svg", alt: "phone icon")
#let email-icon = image("images/envelope-solid.svg", alt: "email icon")
#show: resume.with(
  theme: (
    // margin: 26pt,
    // font: "Libre Baskerville",
    // font-size: 8pt,
    // font-secondary: "Roboto",
    // font-tertiary: "Montserrat",
    // text-color: rgb("#3f454d"),
    // gutter-size: 4em,
    // main-height: 6fr,
    // top-height: 2fr,
    // profile-picture-width: 55%,
  ),
  name: "Paul Dupont",
  profession: "Software Engineer",
  bio: [
    Experienced software engineer with a passion for developing innovative programs that expedite the efficiency and effectiveness of organizational success.],
  profile-picture: image("images/profile_pic_example.jpg", alt: "profile-picture"),
  aside: {
    "Contact"
    set image(width: 8pt)
    contact-entry(
      github-icon,
      link("https://github.com/pauldupont/", "pauldupont"),
    ) + contact-entry(
      phone-icon,
      link("tel:+33 6 78 90 12 34", "+33 6 78 90 12 34"),
    )
    contact-entry(
      email-icon,
      link("mailto:pauldupont@example.com", "pauldupont@example.com"),
    )
    

    section(
      "Main public contributions",
      {
        set text(font: "New Computer Modern", size: 8pt)
        stack(
          spacing: 8pt,
          link(
            "https://github.com/tsnobip/typst-typographic-resume",
            "tsnobip/typst-typographic-resume",
          ),
          link(
            "https://github.com/typst/typst",
            "typst/typst",
          ),
          link(
            "https://github.com/rescript-lang/rescript",
            "rescript-lang/rescript",
          ),
          link(
            "https://github.com/pauldupont/devops-toolkit",
            "pauldupont/devops-toolkit",
          ),
          link(
            "https://github.com/pauldupont/real-time-chat-app",
            "pauldupont/real-time-chat-app",
          ),
        )
      },
    )

    section(
      "Tech Stack",
      {
        set text(font: "New Computer Modern", size: 8pt)
        stack(
          spacing: 8pt,
          "Python",
          "JavaScript",
          "ReScript",
          "React",
          "Node.js",
          "Django",
          "PostgreSQL",
          "Docker",
          "Kubernetes",
        )
      },
    )

    section(
      "Languages",
      {
        language-entry("English", "Native")
        language-entry("Spanish", "Fluent")
        language-entry("German", "Intermediate")
      },
    )

    section(
      "Interests",
      {
        set text(size: 7pt)
        stack(
          spacing: 8pt,
          "Open Source Contributions",
          "Road biking",
          "Traveling",
        )
      },
    )
  },
)


#section(
  theme: (space-above: 0pt),
  "Work Experiences",
  {
    work-entry(
      theme: (
        space-above: 0pt,
      ),
      timeframe: "Jan 2024 - Today",
      title: "Senior Software Engineer for local e-commerce platform",
      organization: "Tech Innovators Inc.",
      location: "Lyon, FR",
      [
        Led a team of developers to design and implement scalable web applications.
        Improved system performance by 30% through code optimization.
        Mentored junior developers, fostering a culture of continuous learning.
        Spearheaded the migration of legacy systems to modern cloud-based infrastructure.
      ],
    )
    work-entry(
      timeframe: "Oct 2020 - December 2023",
      title: "Software Engineer",
      organization: "CodeCraft Solutions",
      location: "San Francisco, USA",
      [
        Developed and maintained RESTful APIs for client applications.
        Collaborated with cross-functional teams to deliver high-quality software.
        Implemented CI/CD pipelines, reducing deployment times by 40%.
        Conducted code reviews to ensure adherence to best practices and coding standards.
      ],
    )
    work-entry(
      timeframe: "Jul 2019 - Oct 2020",
      title: "Junior Software Engineer",
      organization: "NextGen Tech",
      location: "Tbilisi, GE",
      [
        Assisted in the development of e-commerce platforms.
        Wrote unit tests to ensure code reliability and maintainability.
        Participated in agile ceremonies, contributing to sprint planning and retrospectives.
        Researched and implemented new tools to improve development workflows.
      ],
    )
    work-entry(
      timeframe: "Nov 2018 - Jun 2019",
      title: "Intern",
      organization: "Startup Hub",
      location: "Paris, FR",
      [
        Supported the development team in debugging and testing applications.
        Gained hands-on experience with modern web technologies.
        Created technical documentation for internal tools and processes.
        Assisted in the deployment of a new customer-facing web application.
      ],
    )
    work-entry(
      timeframe: "Jun 2017 - Oct 2018",
      title: "Freelance Developer",
      organization: "Self-Employed",
      location: "Remote",
      [
        Designed and developed custom websites for small businesses.
        Provided technical support and maintenance for client projects.
        Built responsive and user-friendly interfaces using modern web technologies.
        Managed multiple projects simultaneously, ensuring timely delivery.
      ],
    )
    work-entry(
      timeframe: "Jan 2016 - May 2017",
      title: "Research Assistant",
      organization: "École des Mines de St-Étienne",
      location: "St-Étienne, France",
      [
        Conducted research on algorithms for optimizing large-scale systems.
        Published findings in peer-reviewed journals and presented at conferences.
        Developed prototypes to validate research concepts.
        Collaborated with a multidisciplinary team to achieve project goals.
      ],
    )
  },
)

#section(
  "Education",
  grid(
    columns: 2,
    column-gutter: default-theme.margin,
    education-entry(
      title: "MSc in Computer Science",
      institution: "École des Mines de St-Étienne, FR",
      timeframe: "2014 - 2017",
      [Focused on software engineering, algorithms, and data structures.],
    ),
    education-entry(
      title: "PhD in Artificial Intelligence",
      institution: "Seoul National University, KR",
      timeframe: "2017 - 2021",
      [Specialized in machine learning and natural language processing.],
    ),
  ),
)
