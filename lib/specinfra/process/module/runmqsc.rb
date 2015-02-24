module Specinfra::Process::Module::Runmqsc
  def runmqsc_result(str)
    lines  = str.split(/\n/)
    header = true
    bodies = []
    body_reset
    lines.each do |line|
      if header and line =~ /1 :/
        # display command
        @command = line.sub(/1\s*:/, "").strip
        next
      elsif header and line !~ /AMQ/
        # skip header
        next
      elsif header and line =~ /AMQ/
        # into body at the first time.
        header = false
        body_reset
        parse_element line
      elsif not header and line =~ /AMQ/
        # into next body
        bodies << @body
        body_reset
        parse_element line
      else
        parse_element line
      end
    end
    unless @body.empty?
      # the last line
      bodies << @body
    end
    bodies
  end

  def parse_element line
    regex  = /([^(]*)\((.*)\)/
    line.strip.split(/\s+/).each do |el|
      match = el.match(regex)
      unless match.nil?
        @body[match[1]] = match[2]
      end
    end
  end

  def body_reset
    @body   = {}
  end
end

