defmodule Vuechat.PageController do
  use Vuechat.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
