FROM timbru31/ruby-node:3.2
ENV TZ=UTC
ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
RUN apt-get update -qq \
  && apt-get install -y curl vim graphviz
WORKDIR /app
