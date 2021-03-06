class Roda
  use Rack::MethodOverride
  plugin :render, escape: true
  plugin :sessions, secret: ENV["SESSION_SECRET"]
  plugin :all_verbs
  plugin :route_csrf
  plugin :public
  plugin :flash

  def api_only(r)
    r.redirect "/" unless r.env["HTTP_ACCEPT"].include?("application/json")
  end

  def login_required(r)
    unless session["current_user_id"]
      flash["message"] = "Please log in to perform this action."
      r.redirect("/")
    end
  end

  def render_json(json)
    response.headers['Content-Type'] = 'application/json'
    response.write(json)
  end

  def render_unprocessable
    response.status = 422
    render_json({}.to_json)
  end

  def flash_ar_errors(object)
    flash.now["message"] = object.errors.full_messages.join(", ")
  end
end
