# CSE 3901 course site redesign

A redesign of the CSE 3901 Carmen pages: Home, Lectures, and Syllabus, plus new Assignments and Resources pages.
Built with Middleman to the same rules as Project 4: the output is only HTML and CSS, with no JavaScript and no CSS framework.

**Two ways to use it:**

1. **Standalone site.** Open `site/index.html` in a browser, or host the `site/` folder anywhere static (GitHub Pages, OSU web space).
2. **Carmen pages.** Canvas strips `<style>` tags, so `carmen/` holds the same pages with every style inlined. Paste each file into the HTML editor of the matching Carmen page. [`carmen/README.md`](carmen/README.md) lists which file goes where.

Both are committed, so nothing needs to be installed to look at the result.

## Editing content

All course content lives in `data/` as YAML. Every page reads from it, so each fact is written once.

| File | Holds |
|---|---|
| `data/course.yml` | Course name, term, room, staff, office hours |
| `data/schedule.yml` | Weeks 1–17: lectures, exams, breaks, files |
| `data/exams.yml` | Exam dates, times, rooms, coverage |
| `data/assignments.yml` | Projects, individual work, policies |
| `data/grading.yml` | Point breakdown and grading scale |
| `data/resources.yml` | Setup guides, textbook, tools |
| `data/carmen.yml` | Which Carmen page each generated page belongs to |

Fixing a date in `schedule.yml` updates the Schedule page, the Home page's "Upcoming" list, and the Carmen version on the next build. Today the same date has to be fixed in up to four places.

## Building

Requires Ruby 3.x and Bundler.

```sh
bundle install
bundle exec middleman server        # live preview at http://localhost:4567
bundle exec middleman build         # writes site/
bundle exec ruby bin/carmen         # writes carmen/ from site/
```

The Home page "Upcoming" list and the "This week" markers are worked out at build time. Rebuild after changing the schedule, or build as of another date with `TODAY=2026-11-02 bundle exec middleman build`.

## Project layout

```
config.rb                 Middleman settings and helpers (dates, icons, nav)
data/                     Course content (YAML)
source/
  layouts/layout.erb      Page shell: head, header, footer
  partials/               Reusable pieces: staff card, exam card, week item, grading
  index.html.erb          Home
  schedule.html.erb       Week-by-week schedule (replaces the Lectures page)
  assignments.html.erb    Projects and policies
  syllabus.html.md.erb    Syllabus summary, written in Markdown
  resources.html.erb      Setup guides, textbook, tools
  stylesheets/site.css    Design tokens and all styles
carmen-src/carmen.css     Canvas-safe styles that bin/carmen inlines
bin/carmen                Builds the paste-ready Carmen pages
site/                     Built standalone site
carmen/                   Built Carmen pages
```

## Design

- Neutral zinc grays with OSU Scarlet (`#ba0c2f`) as the only accent color. Colors, spacing, type sizes, and corner radii are CSS custom properties at the top of `site.css`.
- Responsive layout with CSS Grid, grid areas, and media queries. Sizes use rem, em, and %.
- Dark mode follows the system setting, and the stylesheet has print styles.
- Accessibility: skip link, visible focus outlines, real heading structure, labelled navigation, and WCAG AA contrast throughout.
- Icons are inline SVG from [Lucide](https://lucide.dev) (ISC license). The font is [Inter](https://rsms.me/inter/), with a system-font fallback.

## Checks

- All pages pass the [Nu HTML Checker](https://validator.w3.org/nu/) (the W3C validator) with no errors, and `site.css` passes its CSS check.
- axe-core reports no WCAG 2 A/AA violations on any page, in light or dark mode, for both the standalone and Carmen versions.
- No horizontal scrolling at 390px phone width.

## Content still to fill in

See [`docs/content-notes.md`](docs/content-notes.md) for lecture topics that were not visible to students and for inconsistencies found in the current pages.
