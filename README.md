# IntervalTree ![Specs](https://github.com/chriscz/interval_tree/actions/workflows/ci.yml/badge.svg)

An implementation of a centered interval tree.
Most of the code and tests were translated from the interval-tree ruby project https://github.com/greensync/interval-tree.
Tests were restructured by the data (context) which they work on.
The `unique` feature was dropped because its trivial to run a `uniq` on the returned intervals, however it might be added back in the future.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     interval_tree:
       github: chriscz/interval_tree
   ```

2. Run `shards install`

## Usage

```crystal
require "interval_tree"
```


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/chriscz/interval_tree/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors
- [Chris Coetzee](https://github.com/chriscz) - creator and maintainer of Crystal version

## Ruby Contributors
- [MISHIMA, Hiroyuki](https://github.com/misshie) - creator of the ruby gem
- [Simeon Simeonov](https://github.com/ssimeonov)
- [Carlos Alonso](https://github.com/calonso)
- [Sam Davies](https://github.com/samphilipd)
- [Brendan Weibrecht](https://github.com/ZimbiX)
- [Chris Nankervis](https://github.com/chrisnankervis)
- [Thomas van der Pol](https://github.com/tvanderpol).

## Related Resources
- [The original version written in Ruby](https://github.com/greensync/interval-tree)

## License
The MIT/X11 license
