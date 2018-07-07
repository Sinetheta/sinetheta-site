# Sinetheta Site

A personal website and blog.

## Deployment

Install and configure the [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)

```sh
bundle exec jekyll build
./scripts/deploy.sh <aws_cli_profile> <bucket_name>
```
