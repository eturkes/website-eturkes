# <WARNING>
# Everything within sections like <TAG> is generated and can
# be automatically replaced on deployment. You can disable
# this functionality by simply removing the wrapping tags.
# </WARNING>

# <DOCKER_FROM>
FROM aldryn/base-project:py3-3.23
# </DOCKER_FROM>

# </SSL>
COPY ssl/nginx.conf /etc/nginx/nginx.conf
COPY ssl/snippets/letsencrypt.conf /etc/nginx/snippets/letsencrypt.conf
COPY ssl/snippets/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

# <NODE>
ADD tools/build /stack/boilerplate

ENV NODE_VERSION=0.12.14 \
   NPM_VERSION=2.15.5

RUN bash /stack/boilerplate/install.sh

ENV NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules \
    PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# </NODE>


# <BOWER>
COPY bower.json .bowerrc /app/
RUN bower install \
    --verbose \
    --allow-root \
    --config.interactive=false
# </BOWER>

# <PYTHON>
ENV PIP_INDEX_URL=${PIP_INDEX_URL:-https://wheels.aldryn.net/v1/aldryn-extras+pypi/${WHEELS_PLATFORM:-aldryn-baseproject-py3}/+simple/} \
    WHEELSPROXY_URL=${WHEELSPROXY_URL:-https://wheels.aldryn.net/v1/aldryn-extras+pypi/${WHEELS_PLATFORM:-aldryn-baseproject-py3}/}
COPY requirements.* /app/
COPY addons-dev /app/addons-dev/
RUN pip-reqs compile && \
    pip-reqs resolve && \
    pip install \
        --no-index --no-deps \
        --requirement requirements.urls
# </PYTHON>

# <NPM>
# package.json is put into / so that mounting /app for local
# development does not require re-running npm install
ENV PATH=/node_modules/.bin:$PATH
COPY package.json /
RUN (cd / && npm install --production && rm -rf /tmp/*)
# </NPM>

# <SOURCE>
COPY . /app
# </SOURCE>

# <GULP>
ENV GULP_MODE=production
RUN gulp build
# </GULP>

# <STATIC>
RUN DJANGO_MODE=build python manage.py collectstatic --noinput
# </STATIC>

# minify collected javascript files
# ---------------------------------
RUN python tools/minify.py
