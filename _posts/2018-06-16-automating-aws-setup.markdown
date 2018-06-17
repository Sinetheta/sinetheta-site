---
layout: post
title:  'Automating AWS setup'
date:   2018-06-16 17:30:00 -0700
tags: [devops, ruby, aws]
---
I hate clicking around the AWS console. It reminds me how much of my workflow
is not documented, not repeatable, not fast. Ironically I don't feel that I
make use of enough Amazon Web Services. I think the reason is that I'm not doing
it right.

Today I'd like to share a script I wrote that performs a task common to any new
web project, setting up asset storage with programatic access. On AWS this
means an S3 bucket, an IAM user with permissions for that bucket, and a key pair
for that user.

<style type='text/css'>
  .gist-data { max-height: 245px; }
</style>

<script src="https://gist.github.com/Sinetheta/ef918c21f27ed343d87ab076ffb090ad.js"></script>

## Configuring the AWS CLI

Okay, so small catch-22, to create aws users with api access using the aws api
we're going to need to start with one. The ruby gem [explains where to put your credentials][aws-sdk-ruby-config].
My script only uses a couple IAM and S3 commands, so maybe someday I'll prune
the permissions of my cli credentials. Today I was proud enough to replace my
root keys with device specific users.

## Using Bundler in a single-file Ruby script

I figured that Bundler might have a way to make using gems in scripts easier
[and I was right][bundler-inline]. Thanks Bundler!

{% highlight ruby %}
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'highline'
  gem 'aws-sdk-iam'
  gem 'aws-sdk-s3'
end
{% endhighlight %}

## Prompt for user input

I don't want to get carried away over-engineering this thing but I also would
rather not be editing the script for each use, or opening it up to figure out
which ARGs or ENV I expected to be present. So I decided that [highline][highline]
might be the right amount of user friendliness to walk me through the process
each time.

{% highlight ruby %}
cli = HighLine.new
profile = cli.ask('AWS profile name: ') { |q| q.default = 'default' }
{% endhighlight %}

## Using the ruby aws sdk

I don't know much about the ruby aws sdk, but I know that the [api reference][aws-sdk-ruby-api]
is **huge** and there is [a repo of awesome examples][aws-sdk-ruby-examples]. I
wouldn't say that getting everything I wanted was super easy, but it was pretty
straightforward.

- Identify what I would normally do in the aws console
- Find the equivalent api reference
- Fiddle with the ruby sdk syntax

## See it in action

So how does it work?

![Creating S3 bucket with IAM user]({{ "/assets/images/posts/2018-06-16-automating-aws-setup/aws-s3-script.gif" | absolute_url }})

This gives me the new user credentials, ready to configure the cli, and the url
of a new bucket [optionally] configured as a website. This covers my common use
cases of "new rails project" and "new static website". Let me know if it helps
you at all!

[aws-sdk-ruby-config]: https://github.com/aws/aws-sdk-ruby#configuration
[aws-sdk-ruby-api]: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/index.html
[aws-sdk-ruby-examples]: https://github.com/awsdocs/aws-doc-sdk-examples
[bundler-inline]: https://bundler.io/v1.16/guides/bundler_in_a_single_file_ruby_script.html
[highline]: https://github.com/JEG2/highline
