# GemfileSorter

This gem contains an executable that sorts the contents of a `Gemfile`, 
which is to say that it:

* sorts gemfiles by name
* consolidates duplicate group and source blocks
* pulls inline declarations of group and source 

This is _not_ a sophisticated parser of Gemfiles, and if you do anything 
particularly complicated in your `Gemfile` this system will likely get 
flummoxed. Specifically..

* This system will be confused if you have individual gem declarations that
  span multiple lines.
* This system will be confused if you do dynamic, conditional, or loops in your 
  `Gemfile`.
* This system will be confused if a gem declaration has both an inline group and
  an inline source (this one will likely be fixed).

I'm sure there are other ways this can fail. If you come across such a way, 
please submit your `Gemfile` as an issue and we'll see what we can do.

## Installation and Usage

Installing this as `gem install gemfile_sorter`. You don't need this to be part
of your repo, the command is:

`gemfile_sorter <directory>`

The existing `Gemfile` is moved to `Gemfile.unsorted` and the new `Gemfile` is
put in place. Like, I said, this is still early days, so I'd make sure the new 
Gemfile hasn't lost anything before you use it. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gemfile_sorter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/gemfile_sorter/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GemfileSorter project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gemfile_sorter/blob/master/CODE_OF_CONDUCT.md).
