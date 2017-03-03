# agent_q

[![Join the chat at https://gitter.im/o19s/agent_q](https://badges.gitter.im/o19s/agent_q.svg)](https://gitter.im/o19s/agent_q?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

AgentQ lets you automate your test driven relevancy cases via [Quepid](Quepid.com).  Easily integrate testing your Solr or Elasticsearch search engine into your CI or Continuous Deployment pipeline.   Be confident that you have highly relevant search results without the manual testing!

Run a Quepid case automatically from the command line by passing in a case number (`1139`) and the score threshold for pass or failure (`75`):

```sh
> ./agent_q 1139 75 epugh@opensourceconnections.com $QUEPID_PASSWORD

Case o19s blog search (1139) scored 50.3904, which is below the threshold of 75
```

If the Q Score for the case exceeds the threshold, then AgentQ will return 0, otherwise it returns 1, which signifies to your CI system that there was a failure.


## How it Works
AgentQ is a simple Ruby gem that uses PhantomJS to programmatically interact with Quepid.   You will need to have already installed PhantomJS.   We use AgentQ to verify the search quality for our Jekyll based website at www.opensourceconnections.com.   We just add the gem to our project:

```
# Support CI testing of search with Quepid
gem 'agent_q', '~> 0.0.3'
```

and then call the commandline from CircleCI via this configuration in our `circle.yml` file:

```
test:
  override:
    - bundle exec jekyll build
    - bundle exec agent_q 1139 75 $QUEPID_USER $QUEPID_PASSWORD
```
