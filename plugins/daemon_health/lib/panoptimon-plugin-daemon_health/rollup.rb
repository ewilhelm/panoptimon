class Rollup < Array

def initialize(start, config)
  @start = start
  @start ||= Time.now
  @periods = [60, 15, 5, 1].map {|m| m*60}
  _reset_current(@start)
end

def log (h)
  h.each {|k,v|
    c = @current[1][k] ||= {min: nil, max: nil, sum: 0}
    c[:sum] += v
    c[:min] ||= v; c[:min] = v if v < c[:min]
    c[:max] ||= v; c[:max] = v if v > c[:max]
  }
end

def sunset(horizon)
  cut_here = -1
  self.each {|x| break if x[0] > horizon; cut_here += 1 }
  self.slice!(0..cut_here) if cut_here >= 0
end

def _reset_current (time); @current = [time, {}]; end
def _shortroll(now)
  c = @current
  elapsed = now - c[0]
  self.push(c)
  _reset_current(now)
end

def roll(now)
  self.sunset(now - @periods[0])
  self._shortroll(now)

  agg = Hash[@periods.map {|p| [p, {}]}]
  self.each {|x|
    age = now - x[0]
    thru = (0...@periods.length).to_a.find {|i| age > @periods[i]} ||
      @periods.length
    @periods[0...thru].each {|p|
      x[1].each {|k,v|
        o = agg[p][k] ||= {
          # min: nil, max: nil, # XXX not sure if we need that here
          sum: 0}
        o[:sum] += v[:sum]
        # o[:min] ||= v[:min]; o[:min] = v[:min] if v[:min] < o[:min]
        # o[:max] ||= v[:max]; o[:max] = v[:max] if v[:max] > o[:max]
      }
    }
  }
  up = now - @start
  return Hash[agg.map {|p,h|
    span = up > p ? p : up
    h.each {|k,v| v[:nps] = (v.delete(:sum).to_f / span).round(4)}
    [p.to_s, h]
  }]
  
end

end
