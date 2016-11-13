class GenreDoesNotExist < Exception
end

class NoMoney < Exception
  def initialize(title, price, money)
    @title = title
    @price = price
    @money = money

    super("Для просмотра #{title} надо #{price}, а у вас на счету #{money}")
  end
end

class MovieNotFound < Exception
  def initialize(title)
    super("Фильм с названием \"#{title}\" не найден")
  end
end

class MovieTimeNotFound < Exception
  def initialize(title)
    super("#{title} нет в прокате")
  end
end
