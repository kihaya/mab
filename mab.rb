#!/usr/local/env ruby

require "rubystats"

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
        0
      end
      
      private
            
      def epsilon_greedy_choose
      end
      
      def greedy_choose
      end
      
      def epsilon_choose
      end
    end
  end
end

if __FILE__ == $0
  class A
    include Mab::Base
    
    attr_reader :arms, :rewards, :strategy, :t
    
    def initialize(arms, rewards, strategy, t)
      @arms = arms
      @rewards = rewards
      @strategy = strategy
      @t = t
    end
  end
  
  arms = [Mab::Arm.new(0.2), Mab::Arm.new(0.5)]
  strategy = Mab::Strategy::EpsilonGreedy
  my_mab = A.new(arms, {}, strategy, t=1000)
  
  my_mab.init_reward
  my_mab.run
  p my_mab
end
