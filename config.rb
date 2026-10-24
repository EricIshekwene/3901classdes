require "date"

set :build_dir, "site"
set :css_dir, "stylesheets"
set :layout, "layout"
set :relative_links, true

set :markdown_engine, :kramdown
set :markdown, input: "GFM", auto_ids: true, hard_wrap: false

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

  def nav_link(label, url)
    active = current_page.url.sub(%r{^/}, "") == url || (url == "index.html" && current_page.url == "/")
    attrs = active ? { class: "nav-link is-active", "aria-current" => "page" } : { class: "nav-link" }
    link_to(label, url, attrs)
  end
end
