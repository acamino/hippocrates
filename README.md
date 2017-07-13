![Hippocrates](https://dl.dropboxusercontent.com/s/tjaooqrua7zcfxz/hippocrates.png)

# Hippocrates

[![Build Status](https://travis-ci.org/acamino/hippocrates.svg?branch=master)](https://travis-ci.org/acamino/hippocrates)
[![Coverage Status](https://coveralls.io/repos/github/acamino/hippocrates/badge.svg?branch=master)](https://coveralls.io/github/acamino/hippocrates?branch=master)

Hippocrates is a demo application for managing patients' medical history. It
provides some basic functionality out of the box:

- Search patients
- Manage patients
- Explore patient's medical history
- Manage patient's consultations
  - Register vital signs
  - Register diagnoses
  - Register medical prescriptions

## Dependencies
- Ruby 2.3.1
- Rails 4.2.6
- Postgres

## Local Development

1. Fork the project [on GitHub](https://github.com/acamino/github-stats) and clone your fork locally.

   ```bash
   $ git clone git://github.com/username/hippocrates.git
   $ cd hippocrates
   $ git remote add upstream https://github.com/acamino/hippocrates.git
   ```

1. Run the setup script.

   ```bash
   $ bin/setup
   ```

1. Make sure the tests succeed.

   ```bash
   $ bundle exec rspec
   $ bundle exec cucumber
   ```

1. Start the development server.

   ```bash
   $ bin/rails s
   ```

## Issues & Support

Please [file tickets](https://github.com/acamino/hippocrates/issues) for
bug or problems.

## Contributing

Edits and enhancements are welcome. Just fork the repository, make your changes
and send me a pull request.

## Licence

The code in this repository is licensed under the terms of the
[MIT License](http://www.opensource.org/licenses/mit-license.html).  
Please see the [LICENSE](LICENSE) file for details.
