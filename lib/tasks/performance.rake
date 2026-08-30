# frozen_string_literal: true

# Baseline: parse + serialize timings over the official IPTC examples.
# `rake performance:baseline` writes tmp/performance-baseline.json;
# `rake performance:compare` compares the current run against it (skipped
# with a message when no baseline exists).
namespace :performance do
  ROOT = File.expand_path('../..', __dir__)
  EXAMPLES = File.join(ROOT, 'spec/fixtures/iptc/examples')

  def run_benchmarks
    require 'newsmlg2'
    results = {}
    Dir[File.join(EXAMPLES, '*.xml')].each do |path|
      results[File.basename(path)] = benchmark_document(path)
    end
    results
  end

  def benchmark_document(path)
    source = File.read(path)
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    begin
      Newsmlg2.parse(source).to_xml
    rescue StandardError
      nil
    end
    (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start).round(6)
  end

  def baseline_path
    File.join(ROOT, 'tmp/performance-baseline.json')
  end

  desc 'Write a performance baseline'
  task :baseline do
    require 'json'
    results = run_benchmarks
    FileUtils.mkdir_p(File.dirname(baseline_path))
    File.write(baseline_path, JSON.pretty_generate(results))
    puts "Baseline written: #{baseline_path} (#{results.size} documents)"
  end

  desc 'Compare current performance against the baseline'
  task :compare do
    require 'json'
    unless File.exist?(baseline_path)
      puts "No baseline at #{baseline_path} — run `rake performance:baseline` first."
      next
    end

    baseline = JSON.parse(File.read(baseline_path))
    current = run_benchmarks
    slower = []
    current.each do |name, seconds|
      base = baseline[name]
      next unless base

      ratio = seconds / base
      slower << [name, base, seconds, ratio] if ratio > 1.5
    end
    if slower.empty?
      puts "No document regressed by more than 50% (#{current.size} documents)."
    else
      slower.sort_by { |(_, _, _, ratio)| -ratio }.first(10).each do |name, base, now, ratio|
        warn format('%<name>s: %<base>.4fs -> %<now>.4fs (%<ratio>.2fx)', name: name, base: base, now: now,
                                                                          ratio: ratio)
      end
      raise 'performance regression detected'
    end
  end
end
