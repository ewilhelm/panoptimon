
require 'net/smtp'
require 'mail'

interval = config[:interval] || 60
smtp_args = config[:smtp_settings]
mail_args = {
  to:      config[:to] || raise("must have 'to' address for e-mail"),
  from:    config[:from] ||
    (ENV['USER'] + '@' + File.new('/etc/hostname').readline.chomp),
  subject: 'panoptimon update',
}

matches = config[:match] \
  ? config[:match].map {|m| %r{#{m}}}
  : nil

current = {} # per-granule
setup = ->() {
EM.add_periodic_timer(interval, ->(){

  body = current.keys.count == 0 ? "---\n"
    : current.keys.sort {|a,b| a <=> b}.map {|t|
    next if current[t].keys.count == 0
    "#{t}: #{JSON.generate(current[t])}"}.join("\n") + "\n"
  msg = ::Mail::Message.new( mail_args.merge({ body: body }) )
  begin;
  ::Net::SMTP.start( * smtp_args.values_at(
    :address, :port, :domain,
    :user_name, :password, :authentication
  )) {|s| s.send_message(msg.to_s, msg.from[0], msg.to) }
  rescue;
    logger.warn("mail error: #{$!}")
  end

  current = {}
})
}

->(metric) {
  if setup; setup[] ; setup = nil; end

  # collect / filter -> relay
  t = Time.now.to_i
  metric.each {|k,v|
    next if matches and not(matches.find {|m| k =~ m})
    store = current[t] ||= {}
    store[k] = v # NOTE 1sec granularity / TODO conf[:granularity]?
  }


}
