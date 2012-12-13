class Rollup < Array

def initialize(start, config)
  @start = start
  @start ||= Time.now
  @periods = [60, 15, 5, 1].map {|m| m*60}

end

def log (t, h)
  self.push([t,h])
end

def roll(now)
  horizon = now - @periods[0]
  cut_here = -1
  p = 0
  sums = Hash[@periods.map {|p| [p, Hash.new(0)]}]
  self.each {|x|
    if p == 0 and x[0] < horizon
      cut_here += 1
      next
    elsif @periods[p] and x[0] > now - @periods[p]
      p += 1
    end
    warn "p: #{p}"
    @periods[p...@periods.length].each {|_|
      x[1].each {|k,v| sums[_][k] += v} # min/max/n?
    }
  }
  self.slice!(0, cut_here) if cut_here
  up = now - @start
  return Hash[sums.map {|p,h|
    div = up > p ? p : up
    [p.to_s, Hash[h.map {|k,v| [k, (v.to_f/div).round(4)]}]]
  }]
  
end

end
