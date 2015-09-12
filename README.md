# Prpr::Gemfile

[Prpr](https://github.com/mzp/prpr) plugin to annotate major/minor version changing at `Gemfile.lock`.

## Install

Add this line to your application's Gemfile:

```ruby
gem 'prpr-gemfile'
```

## Usage
Post annotate comment to major/minor version changing at `Gemfile.lock` of pull request.

![gemfile](https://raw.githubusercontent.com/mzp/prpr-gemfile/master/gemfile.png)

## Env

```
MAJOR_VERSION_COMMENT - comment for major version change (Default: ":eyes: major version is changed")
MINOR_VERSION_COMMENT - comment for minor version change (Default: ":eyes: major version is changed")
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

