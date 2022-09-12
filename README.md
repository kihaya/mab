## mab

Multi-armed bandit algorithm just in one ruby file.
This program is experimental poc and for toy use.

### Usage

```ruby

ruby mab.rb

#<Mab::Bandit:0x0000000104cd74b8 @arms=[#<Mab::Arm:0x0000000104cd7738 @prob=0.2>, #<Mab::Arm:0x0000000104cd7670 @prob=0.5>, #<Mab::Arm:0x0000000104cd7620 @prob=0.6>], @rewards={0=>146, 1=>322, 2=>402}, @strategy=Mab::Strategy::EpsilonGreedy, @t=2000>
````

or in irb,

```ruby
lib(main):001:0> require_relative "mab"
=> true
irb(main):003:0> Mab::Arm.new(0.1)
=> #<Mab::Arm:0x000000011338ec80 @prob=0.1>
```
