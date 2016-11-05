class GenreDoesNotExist < Exception
end

class NoMoney < Exception
  def initialize(title, price, money)
    super("Для просмотра #{title} надо #{price}, а у вас на счету #{money}")
  end
end

class MovieNotFound < Exception
  def initialize(title)
    super("Фильм с названием \"#{title}\" не найдет")
  end
end
