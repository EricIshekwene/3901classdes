# Content notes

Every course fact on the site (dates, rooms, points, policies, names) came from the current Carmen pages as a student sees them. Nothing was guessed. The only new writing is short introductory text, such as the line under the Home page title. These are the gaps and the inconsistencies found along the way.

## Missing from the schedule

`data/schedule.yml` only lists lectures whose topics could be confirmed. These show "Topic posted in Carmen Modules" until they are filled in:

- Lectures 2–4 and 6–13 (weeks 1–5)
- Lectures 16–18 (weeks 6–7)
- Lectures 21–25 (weeks 9–10)
- Lectures 27 and 30–34 (weeks 11–13)
- Exact dates for most lectures. Week date ranges are worked out from the term start.

Lecture files link to Carmen Modules rather than to individual files, because file links need Carmen file IDs.

## Inconsistencies in the current pages

| What | Where | Detail |
|---|---|---|
| Schedules disagree | Syllabus vs. Lectures vs. Modules | The Syllabus weekly table puts HTML/CSS in week 5 and Rails in weeks 9–10 and stops at week 11. Lectures and Modules put HTML/CSS in weeks 6–8 and Rails in weeks 11–13. This site follows Lectures and Modules. |
| Term end date | Syllabus | "August 26 to December 9", but the final exam is December 16 |
| Course name | Home, Lectures, Syllabus | "CS 3901 · Web-Based Project", "CSE 3901 – Web-Based Project", and two versions of the full title. This site uses "CSE 3901" and the Syllabus title. |
| Textbook year | Syllabus vs. Modules | "(2023)" vs. "2022" |
| Lecture numbering | Lectures | No Lecture 14 or 28 |
| Navigation line | Home | "Course Information · Instructional Staff · Lectures · Office Hours" looks like links but isn't |
| Course Resources | Syllabus | The section is empty |
| Arrow images | Syllabus | "Carmen → People → Project Groups" uses LaTeX images, which screen readers read as "LaTeX: \hookrightarrow" |
| Lectures table width | Lectures | `min-width: 850px` makes the table wider than the Carmen content area, so it scrolls sideways even on desktop |
| Grader office hours | Home | Still "TBD" |

## Open questions

- Should the Carmen pages replace the current ones, or should the standalone site be hosted somewhere?
- Is OSU branding (header, footer, logo) required for a standalone version?
- The Carmen versions have not been pasted into Canvas yet. They stick to basic CSS (flexbox, borders, colors, spacing) to give them the best chance with the Canvas sanitizer, but preview each page after pasting.
