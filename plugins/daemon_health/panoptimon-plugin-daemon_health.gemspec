Gem::Specification.new { |s|
  s.name = 'panoptimon-plugin-daemon_health'
  s.version = '0.0.1'
  s.summary = 'report internal daemon metrics'
  s.authors = ['Eric Wilhelm']

  s.files         = `git ls-files`.split($\)

  s.add_dependency 'rusage'
}
