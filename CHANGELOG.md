# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2023-10-28

### Added

- Add SuperAGI::Agent#update to create a new agent.
- Add SuperAGI::Agent#run to run an agent.
- Add SuperAGI::Agent#status to get the status of an agent run.

## [0.1.0] - 2023-10-25

### Added

- Initialise repository.
- Add SuperAGI::Client to connect to SuperAGI API using user credentials.
- Add SuperAGI::Agent#create to create a new agent.
- Add spec for Client with a cached response using VCR.
- Add CircleCI to run the specs on pull requests.
