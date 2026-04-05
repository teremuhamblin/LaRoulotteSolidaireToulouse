# scripts/API/lib/json_helpers.rb
# frozen_string_literal: true

module JsonHelpers
  def json_ok(payload = {}, status: 200)
    halt status, json({ ok: true, data: payload })
  end

  def json_error(code, status, details: nil)
    body = { ok: false, error: { code: code, status: status } }
    body[:error][:details] = details if details
    halt status, json(body)
  end
end
