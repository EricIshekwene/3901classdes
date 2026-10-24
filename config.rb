require "date"

set :build_dir, "site"
set :css_dir, "stylesheets"
set :layout, "layout"
set :relative_links, true

set :markdown_engine, :kramdown
set :markdown, auto_ids: true, smart_quotes: %w[lsquo rsquo ldquo rdquo]

activate :relative_assets

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

# Pages build relative to this date so the "Upcoming" list stays honest.
# Override with TODAY=2026-11-01 bundle exec middleman build
set :today, ENV["TODAY"] ? Date.parse(ENV["TODAY"]) : Date.today

helpers do
  def to_date(value)
    value.is_a?(Date) ? value : Date.parse(value.to_s)
  end

  def short_date(value)
    to_date(value).strftime("%a, %b %-d")
  end

  def long_date(value)
    to_date(value).strftime("%A, %B %-d, %Y")
  end

  def week_range(week)
    start = to_date(data.course.term.first_monday) + (week.number - 1) * 7
    finish = start + 4
    "#{start.strftime('%b %-d')} – #{finish.strftime(start.month == finish.month ? '%-d' : '%b %-d')}"
  end

  def current_week_number
    start = to_date(data.course.term.first_monday)
    ((config[:today] - start).to_i / 7) + 1
  end

  # Every dated item in the course, soonest first, from today on.
  def upcoming_items(limit = 5)
    items = []
    data.exams.each do |exam|
      items << { date: to_date(exam.date), kind: "exam", title: exam.name,
                 detail: "#{exam.time} · #{exam.room}", href: "index.html#exams" }
    end
    data.assignments.projects.each do |project|
      next unless project.due
      items << { date: to_date(project.due), kind: "due", title: "#{project.name} due",
                 detail: project.due_time, href: "assignments.html" }
    end
    data.schedule.weeks.each do |week|
      week.items.each do |item|
        next unless item.kind == "break" && item.date
        items << { date: to_date(item.date), kind: "break", title: item.title,
                   detail: "No class", href: "schedule.html#week#{week.number}" }
      end
    end
    items.select { |i| i[:date] >= config[:today] }.sort_by { |i| i[:date] }.first(limit)
  end

  def days_until(date)
    days = (to_date(date) - config[:today]).to_i
    case days
    when 0 then "Today"
    when 1 then "Tomorrow"
    else "In #{days} days"
    end
  end

  # Lucide icons (ISC license), inlined so the site needs no icon font or script.
  ICONS = {
    "mail" => '<rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>',
    "pin" => '<path d="M20 10c0 4.993-5.539 10.193-7.399 11.799a1 1 0 0 1-1.202 0C9.539 20.193 4 14.993 4 10a8 8 0 0 1 16 0"/><circle cx="12" cy="10" r="3"/>',
    "clock" => '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
    "arrow-right" => '<path d="M5 12h14"/><path d="m12 5 7 7-7 7"/>',
    "external" => '<path d="M7 7h10v10"/><path d="M7 17 17 7"/>',
    "file" => '<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/>',
    "book" => '<path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>',
    "code" => '<polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/>',
    "calendar" => '<rect width="18" height="18" x="3" y="4" rx="2"/><path d="M16 2v4"/><path d="M8 2v4"/><path d="M3 10h18"/>'
  }.freeze

  def icon(name)
    %(<svg class="icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">#{ICONS.fetch(name)}</svg>)
  end

  def initials(name)
    name.split.map { |part| part[0] }.join[0, 2]
  end

  def carmen(path = "")
    data.course.carmen_url + path
  end

  def nav_link(label, url)
    active = current_page.url.sub(%r{^/}, "") == url || (url == "index.html" && current_page.url == "/")
    attrs = active ? { class: "nav-link is-active", "aria-current" => "page" } : { class: "nav-link" }
    link_to(label, url, attrs)
  end
end
