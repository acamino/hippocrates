![Hippocrates](https://dl.dropboxusercontent.com/s/tjaooqrua7zcfxz/hippocrates.png)

# Hippocrates

[![CI](https://github.com/acamino/hippocrates/actions/workflows/ci.yml/badge.svg)](https://github.com/acamino/hippocrates/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/acamino/hippocrates/branch/main/graph/badge.svg)](https://codecov.io/gh/acamino/hippocrates)

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
- Ruby 3.4.4
- Rails 8.1
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
