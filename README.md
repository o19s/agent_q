# Agent Q

[![Join the chat at https://gitter.im/o19s/agent_q](https://badges.gitter.im/o19s/agent_q.svg)](https://gitter.im/o19s/agent_q?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


AgentQ lets you automate your test driven relevancy cases via [Quepid](http://www.quepid.com).  Easily integrate testing your Solr or Elasticsearch search engine into your CI or Continuous Deployment pipeline.   Be confident that you have highly relevant search results without the manual testing!

Run a Quepid case automatically from the command line by passing in a case number (`1139`) and the score threshold for deciding if your search results pass or fail (`10`):

```sh
> ./agent_q 1139 10 epugh@opensourceconnections.com $QUEPID_PASSWORD http://app.quepid.com

Case o19s blog search (1139) scored 10.0, which meets the threshold of 10
```

If the Q Score for the case meets the threshold, then AgentQ will return 0, otherwise it returns 1, which signifies to your CI system that there was a failure.


## How it Works
AgentQ is shipped as a simple Ruby gem that uses PhantomJS to programmatically interact with the rich web application hosted at [Quepid.com](http://www.quepid.com).  Start by installing PhantomJS.  We use AgentQ to verify the search quality of [our website](http://www.opensourceconnections.com).  We added the gem to our Jekyll project:

```
# Support CI testing of search with Quepid
gem 'agent_q', '~> 0.0.9'
```

and then call AgentQ from CircleCI via this line in our `circle.yml` file:

```
test:
  override:
    - bundle exec jekyll build
      - bundle exec agent_q 1139 75 $QUEPID_USER $QUEPID_PASSWORD http://app.quepid.com
```
