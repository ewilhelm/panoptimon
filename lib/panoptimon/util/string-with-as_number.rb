class String; def as_number # from perlfaq4
  self =~ %r{\A[+-]?(?=\.?\d)\d*\.?\d*(?:[Ee][+-]?\d+)?\z} \
  ? (self =~ %r{[\.Ee]} ? self.to_f : self.to_i)
  : nil
end; end
