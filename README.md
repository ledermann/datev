# Datev

Ruby gem to export bookings and more to DATEV format as CSV file

Supported DATEV format: v7.0

[![Build Status](https://travis-ci.org/ledermann/datev.svg?branch=master)](https://travis-ci.org/ledermann/datev)
[![Code Climate](https://codeclimate.com/github/ledermann/datev/badges/gpa.svg)](https://codeclimate.com/github/ledermann/datev)
[![Coverage Status](https://coveralls.io/repos/github/ledermann/datev/badge.svg?branch=master)](https://coveralls.io/github/ledermann/datev?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'datev'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install datev

## Usage

To export bookings, you need an BookingExport instance with an array of records. Example:

```ruby
export = Datev::BookingExport.new(
  'Herkunft'        => 'XY',
  'Exportiert von'  => 'Chief Accounting Officer',
  'Berater'         => 1001,
  'Mandant'         => 456,
  'WJ-Beginn'       => Date.new(2018,1,1),
  'Datum vom'       => Date.new(2018,2,1),
  'Datum bis'       => Date.new(2018,2,28),
  'Bezeichnung'     => 'Beispiel-Buchungen'
) # For available hash keys see /lib/datev/base/header.rb

export << {
  'Belegdatum'                     => Date.new(2018,2,21),
  'Buchungstext'                   => 'Fachbuch: Controlling für Dummies',
  'Umsatz (ohne Soll/Haben-Kz)'    => 24.95,
  'Soll/Haben-Kennzeichen'         => 'H',
  'Konto'                          => 1200,
  'Gegenkonto (ohne BU-Schlüssel)' => 4940,
  'BU-Schlüssel'                   => '8'
} # For available hash keys see /lib/datev/base/booking.rb

export << {
  'Belegdatum'                     => Date.new(2018,2,22),
  'Buchungstext'                   => 'Honorar FiBu-Seminar',
  'Umsatz (ohne Soll/Haben-Kz)'    => 5950.00,
  'Soll/Haben-Kennzeichen'         => 'S',
  'Konto'                          => 10000,
  'Gegenkonto (ohne BU-Schlüssel)' => 8400,
  'Belegfeld 1'                    => 'RE201802-135'
}

export.to_file('EXTF_Buchungsstapel.csv')
```

Result: [CSV file](examples/EXTF_Buchungsstapel.csv)

All records are validated against the defined schema.

Beside bookings, some other exports are available, too:

* `AccountExport` ("Kontenbeschriftungen")
* `ContactExport` ("Stammdaten")


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ledermann/datev. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
