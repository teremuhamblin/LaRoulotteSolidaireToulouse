#!/usr/bin/env ruby
# ==============================================================================
#  La Roulotte Solidaire Toulouse
#  Script : test_suite.rb
#  Version : 1.1.0
#  Objectif :
#     - Tester automatiquement les composants du projet
# ==============================================================================

require "json"
require "open3"
require "net/http"

BASE = File.expand_path("../../", __dir__)
REPORTS = "#{BASE}/reports"

def test(title)
  print "[TEST] #{title}... "
  yield
  puts "OK"
rescue => e
  puts "FAIL"
  puts "  -> #{e.message}"
end

# --- Test API -----------------------------------------------------------------
test("API /status répond") do
  uri = URI("http://localhost:4567/status")
  res = Net::HTTP.get_response(uri)
  raise "Code HTTP #{res.code}" unless res.code == "200"
end

# --- Test scripts Bash --------------------------------------------------------
test("maintenance_roulotte.sh exécutable") do
  path = "#{BASE}/scripts/maintenance/maintenance_roulotte.sh"
  raise "Non trouvé" unless File.exist?(path)
  raise "Non exécutable" unless File.executable?(path)
end

# --- Test scripts Python ------------------------------------------------------
test("maintenance_report.py génère un JSON valide") do
  script = "#{BASE}/scripts/maintenance/maintenance_report.py"
  out, err, status = Open3.capture3("python3 #{script}")
  raise "Erreur Python" unless status.success?

  files = Dir["#{REPORTS}/*.json"]
  raise "Aucun rapport généré" if files.empty?

  JSON.parse(File.read(files.last))
end

# --- Test dossiers ------------------------------------------------------------
test("Dossiers essentiels présents") do
  %w[logs reports scripts docs].each do |d|
    raise "Dossier manquant : #{d}" unless Dir.exist?("#{BASE}/#{d}")
  end
end

puts "\nTous les tests sont terminés."
