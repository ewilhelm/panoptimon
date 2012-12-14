class Rollup < Array

def initialize(start, config)
  @start = start
  @start ||= Time.now
  @periods = [60, 15, 5, 1].map {|m| m*60}

end

def log (t, h)
  self.push([t,h])
end

def sunset(horizon)
  cut_here = -1
  self.each {|x| break if x[0] > horizon; cut_here += 1 }
  self.slice!(0..cut_here) if cut_here >= 0
end

def roll(now)
  self.sunset(now - @periods[0])

  sums = Hash[@periods.map {|p| [p, Hash.new(0)]}]
  self.each {|x|
    age = now - x[0]
    thru = (0...@periods.length).to_a.find {|i| age > @periods[i]} ||
      @periods.length
    @periods[0...thru].each {|p|
      x[1].each {|k,v| sums[p][k] += v} # min/max/n?
    }
  }
  up = now - @start
  return Hash[sums.map {|p,h|
    div = up > p ? p : up
    [p.to_s, Hash[h.map {|k,v| [k, (v.to_f/div).round(4)]}]]
  }]
  
end

end
