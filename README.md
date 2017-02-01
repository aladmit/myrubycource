# Theaters

Theaters is a lib that provides a functional of Theatre and Netflix.

## WARNING

Its a joke! You should not use it! Its only for my ruby course!

## Usage

### Theatre

```ruby
theatre = Theaters::Theatre.new('file_with_movies.txt')
```

Method `show` should get you a movie:

```ruby
theatre.show
# => "Now showing: The Shawshank Redemption 2017-01-29 17:11:22 +0300 - 2017-01-29 19:33:22 +0300"
```

A more flexible way to use `show` is to set a time. Theater have a 3 times for movies: morning, middle, evening.
In the morning(8:00 - 11:00) you can see ancient movies.
In the middle(12:00 - 16:00) you can see comedy and action movies.
In the evening(17:00 - 22:00) you can see drama and horror movies.
Example:

```ruby
theatre.show('10:00')
# => "Now showing: Casablanca 2017-01-29 17:17:15 +0300 - 2017-01-29 18:59:15 +0300"
```

Or you can set yours rules by DSL.

```ruby
Theaters::Theatre.new do
	hall :red, title 'Красный зал', places: 100

	period '09:00'..'11:00' do
		description 'Утренний сеанс'
		filters genre: 'Comedy', year: 1900..1980
		price 10
		hall :red
	end
end
```

### Netflix

```ruby
netflix = Theaters::Netflix.new('file_with_movies.txt')
```

You should pay for movies:

```ruby
netflix.pay(20)
```

Method `show` should get you a random movie and take the money:

```ruby
netflix.show
# => "Now showing: The Shawshank Redemption - современное кино, играют: Tim Robbins, Morgan Freeman, Bob Gunton"
```

But you can set a filters by params:

```ruby
netflix.show(producer: 'Oliver Stone', period: :modern)
# => "Now showing: Platoon - современное кино, играют: Charlie Sheen, Tom Berenger, Willem Dafoe"
```

Or by a block:

```ruby
netflix.show { |movie| movie.producer.include?('Oliver Stone') }
# => "Now showing: Platoon - современное кино, играют: Charlie Sheen, Tom Berenger, Willem Dafoe"
```

#### Price list

Ancient $1
Classic $1.5
Modern  $3
New     $5
