# Contributing to grape_logging

This project is work of many contributors. You're encouraged to submit pull requests, propose features and discuss issues.

## Fork the Project

Fork the project on Github and check out your copy.

```
git clone https://github.com/contributor/grape_logging.git
cd grape_logging
git remote add upstream https://github.com/aserafin/grape_logging.git
```

## Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

## Bundle Install and Test

Ensure that you can build the project and run tests.

```
bundle install
bundle exec rake
```

## Write Tests

Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build. Add to the spec directory.

## Write Code

Implement your feature or bug fix.

Ruby style is enforced with RuboCop. Run `bundle exec rubocop` and fix any style issues highlighted.

Make sure that `bundle exec rake` completes without errors.

## Write Documentation

Document any external behavior in the README.md.

## Update Changelog

Add a line to Changelog.md under *Next Release*. Make it look like every other line, including your name and link to your Github account.

## Commit Changes

Make sure git knows your name and email address:

```
git config --global user.name "Your Name"
git config --global user.email "contributor@example.com"
```

Writing good commit logs is important. A commit log should describe what changed and why.

```
git add ...
git commit
```

## Push

```
git push origin my-feature-branch
```

## Make a Pull Request

Go to https://github.com/contributor/grape_logging and select your feature branch. Click the 'Pull Request' button and fill out the form.

We'll try to review pull requests within a few days but as this is maintained by a small group of volunteers there is no guarantee that we'll look at it within any time frame, or at all. There's no maintenance guarantee.

## Discuss and Update

You may get feedback or requests for changes to your pull request. This is a big part of the submission process so don't be discouraged!

Some things that will increase the chance that your pull request is accepted:

- Write tests.
- Follow the Ruby style guide.
- Write a good commit message.

If you'd like to discuss a feature or bug fix before starting work, please [create an issue](https://github.com/aserafin/grape_logging/issues) first. This helps ensure your contribution aligns with the project's direction and avoids duplicate efforts.

## Rebase

If you've been working on a change for a while, rebase with upstream/master.

```
git fetch upstream
git rebase upstream/master
git push origin my-feature-branch -f
```

## Be Patient

It's likely that your change will not be merged and that the nitpicky maintainers will ask you to do more, or fix seemingly benign problems. Hang in there!

## Thank You

Please do know that we really appreciate and value your time and work. We love you, really.
