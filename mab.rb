#!/usr/local/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'matrix'
  gem 'rubystats'
end

module Mab
  class Arm
    attr_reader :prob
    
    def initialize(prob)
      @prob = prob
    end
  end
  
  module Base
    def pull_arm(arms, choise)
      p = arms[choise].prob
      dist = Rubystats::BinomialDistribution.new(1, p)
      dist.rng
    end
    
    def init_reward
      @arms.each_with_index do |_elm, i|
        @rewards[i] = 0
      end
    end
    
    def run  
      @t.times do
        strategy = @strategy.new(@arms, @rewards, 0.1)
        choise = strategy.choose
        r = pull_arm(@arms, choise)
        @rewards[choise] = @rewards[choise] + r
      end
    end
  end
  
  class Bandit
    include Mab::Base

    attr_reader :arms, :rewards, :strategy, :t

    def initialize(arms, rewards, strategy, t)
      @arms = arms
      @rewards = rewards
      @strategy = strategy
      @t = t
    end
  end

  module Strategy
    class Base
      attr_reader :arms, :rewards, :epsilon

      def initialize(arms, rewards, epsilon=0.1)
        @arms = arms
        @rewards = rewards
        @epsilon = epsilon
      end
      
      def choose
        raise StandardError.new("Please implement strategy")
      end
    end

    class EpsilonGreedy < Base
      def choose
        epsilon_greedy_choose
      end
      
      private
            
      def epsilon_greedy_choose
        dist = Rubystats::BinomialDistribution.new(1, @epsilon)
        if dist.rng
          epsilon_choose
        else
          greedy_choose
        end
      end
      
      def greedy_choose
        # Choose arm that has max rewards value in history
        # same as argmax rewards
        @rewards.invert.max.last
      end
      
      def epsilon_choose
        (0...@arms.length).to_a.sample
      end
    end
  end
end

if __FILE__ == $0
  my_mab = Mab::Bandit.new([Mab::Arm.new(0.2),
                            Mab::Arm.new(0.5),
                            Mab::Arm.new(0.6)],
                           {},
                           strategy,
                           t=2000)
  
  my_mab.init_reward
  my_mab.run
  p my_mab
end
