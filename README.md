# luacov-reporter-gcovr

A [luacov](https://keplerproject.github.io/luacov/) reporter that
creates [gcovr json files](https://gcovr.com/en/stable/guide.html#json-output).

Requires a JSON module (dkjson or cjson).

## Installation

Luarocks:

```bash
luarocks install luacov-reporter-gcovr
```

Make:

```bash
make install
```

## Usage

Generate your luacov stats file (pass `-lluacov` or run `busted -c`), then:

```bash
luacov -r gcovr

# luacov.report.out is a json file that can be read by gcovr.

gcovr --add-tracefile luacov.report-out --html-details coverage.html
```

## Limitations

No branch listing, I don't think `luacov` handles branch coverage, just line coverage.

Not sure if this output is quite right - I'm seeing lines showing as missed even though I know
they've been hit. So this is still a work-in-progress.

## LICENSE

MIT (see `LICENSE`)
