class Dashboard
  def self.weekdays
    dates_week(Date.today).map {|day| day.strftime("%A")}
  end

  def self.dates_week(d)
    d.beginning_of_week..(d.beginning_of_week+6)
  end

  def self.menus
    menus = {}
    dates_week(Date.today).each  do |day|
      menus[day] = Menu.where("created_at::date = ?", day).first
    end
    menus
  end

  def self.monthdays(date)
    date.beginning_of_month.upto(date.end_of_month)
  end
end