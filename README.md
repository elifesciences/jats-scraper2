# bot-lax-adaptor

This application:

1. listens for messages from the [elife-bot](https://github.com/elifesciences/elife-bot)
2. downloads xml from S3 via HTTP
3. converts it to a partial representation of our [article-json schema](https://github.com/elifesciences/api-raml)
4. sends article-json to [Lax](https://github.com/elifesciences/lax) to be ingested

## installation

    $ ./install.sh
    
This will create a default `app.cfg` file. You can edit the app.cfg file to set the `cache_path` value to another directory if the `.` default doesn't suit you:

```
cache_path: /tmp
```

## web interface

The bot-lax-adaptor comes with a simple web GUI that allows uploading arbitrary
jats xml, generating article-json from it and validating it.

    $ ./web.sh

## conversion

    $ source venv/bin/activate
    $ python src/main.py /path/to/a/jats.xml

Output at time of writing [looks like this](example-article.json).

### convert specific article

Thin wrapper around the above command:

    $ ./scrape-article.sh ./article-xml/articles/elife-09560-v1.xml

### convert random article

Converts a random article to article-json:

    $ ./scrape-random-article.sh

### convert *all* articles

Converts all articles in the `./article-xml/articles/` directory, writing the
results to `./article-json/`. This script makes use of all available cores:

    $ ./generate-article-json.sh

## validation

The article-json generated by this application is structured according to the
[eLife json-schema article specification](https://github.com/elifesciences/api-raml).

Because the XML only contains a partial representation of an article, validation
also involves filling in certain gaps that can only be provided by Lax.

    $ source venv/bin/activate
    $ python src/validate.py /path/to/an/article.json

### validate specific article-json

Thin wrapper around above command:

    $ ./validate-json.sh ./article-json/elife-09560-v1.xml.json

### validate *all* article-json

Validates all article-json in the `./article-json/` directory. This script makes
use of all available cores:

    $ ./validate-all-json.sh

## listening/sending

### populating a Lax installation

This script ties several others together and simply does: generate, validate and
then an `ingest --force` to lax.

    $ ./backfill.sh

### receiving messages from an AWS SQS queue

This is quite eLife-specific but can be modified easily if you're a developer:

    $ ./bot-lax-listener.sh

## testing

```
    $ ./test.sh
    # single test
    $ source venv/bin/activate
    # PYTHONPATH=src green src.tests.test_utils
```

## Copyright & Licence

Copyright 2016 eLife Sciences. Licensed under the [GPLv3](LICENCE.txt)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
