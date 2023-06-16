# Cocoapods no autoimports?

A cocoapods plugin that let's you hook in generating umbrella and prefix headers for pods. And remove autoimports of 
1. `UIKit`.h 
2. `Cocoa`.h 
3. `Foundation`.h

## ⭐ Usage

Add this line to your application's Gemfile:

```ruby
gem 'cocoapods-no-autoimports'
```

Add this line to your Podfile:
```ruby
plugin 'cocoapods-no-autoimports'
```

Execute:

    $ bundle install

Now run:

    $ pod install

Done! Now go and check your Xcode build erros 😁


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
