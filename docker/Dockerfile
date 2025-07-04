FROM ruby:3.2.6-slim

# ARG for setting the application user ID dynamically
ARG APP_USER_ID

# Environment Variables
ENV APP_USER ticket-notification-user
ENV PROJECT_DIRECTORY ticket-notification
ENV USER_HOME_DIRECTORY /home/${APP_USER}
ENV APP_PATH ${USER_HOME_DIRECTORY}/${PROJECT_DIRECTORY}
ENV CACHE_DIR ${APP_PATH}/tmp/cache
ENV NODE_MODULES_DIR ${APP_PATH}/node_modules
ENV BUNDLED_GEMS_PATH /bundle
ENV BUNDLE_APP_CONFIG ${BUNDLED_GEMS_PATH}
ENV BUNDLE_BIN ${BUNDLED_GEMS_PATH}/bin
ENV BUNDLE_PATH ${BUNDLED_GEMS_PATH}
ENV PATH ${BUNDLE_BIN}:${PATH}

# Install required libraries and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
    curl \
    bash bash-completion \
    vim \
    nodejs \
    yarn \
    tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# Create application user and set up directories
RUN useradd -md ${USER_HOME_DIRECTORY} -u ${APP_USER_ID} -s /bin/bash ${APP_USER} && \
    mkdir -p ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR} && \
    chown -R ${APP_USER}:${APP_USER} ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR}

WORKDIR ${USER_HOME_DIRECTORY}

# Add entrypoint script
# Copy entrypoint to docker home directory
COPY docker/entrypoint.sh ${USER_HOME_DIRECTORY}/entrypoint.sh
RUN chmod +x ${USER_HOME_DIRECTORY}/entrypoint.sh

# Configure Rails console history
RUN echo "require 'irb/ext/save-history'\n\
IRB.conf[:SAVE_HISTORY] = 500\n\
IRB.conf[:HISTORY_FILE] = '${APP_PATH}/.irb-history'\n" >> ${USER_HOME_DIRECTORY}/.irbrc

# Switch to application user
USER ${APP_USER}

# Set working directory
WORKDIR ${APP_PATH}

# Copy Gemfile and Gemfile.lock
COPY --chown=${APP_USER} Gemfile .
COPY --chown=${APP_USER} Gemfile.lock .

# Install gems
RUN bundle install --jobs $(getconf _NPROCESSORS_ONLN) --retry 3
