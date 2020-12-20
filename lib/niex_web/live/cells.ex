defmodule NiexWeb.Cells do
  use Phoenix.LiveComponent
  import Phoenix.HTML

  def render(
        assigns = %{
          idx: idx,
          selected: true,
          cell: %{cell_type: "markdown"}
        }
      ) do
    ~L"""
    <div class="cell markdown"  class="cell"  phx-value-ref="<%= idx %>" phx-blur="blur-cell">
      <form phx-change="update-content" phx-blur="blur-cell" phx-value-ref="<%= idx %>">
        <input type="hidden" name="index" value="<%= idx %>" />
        <input type="hidden" name="cell_type" value="markdown" />
        <textarea autofocus phx-blur="blur-cell" phx-value-ref="<%= idx %>" phx-focus="focus-cell" name="text" phx-hook="NiexEditor" id="cell-text-<%= idx %>"><%= @cell[:content] %></textarea>
      </form>
      <div class="toolbar">
        <button class="remove" phx-click="remove-cell" phx-value-index="<%= idx %>" phx-disable-with="Removing...">
          <i class="fas fa-trash"></i>
        </button>
      </div>
    </div>
    """
  end

  def render(
        assigns = %{
          idx: idx,
          cell: %{
            cell_type: "markdown"
          }
        }
      ) do
    {:ok, html, _} = Earmark.as_html(Enum.join(assigns[:cell][:content], "\n"))

    ~L"""
    <div class="cell markdown" phx-click="focus-cell" phx-blur="blur-cell" class="cell" phx-value-ref="<%= idx %>">
      <div class="content"><%= raw(html) %></div>
    </div>
    """
  end

  def render(
        assigns = %{
          cell: %{
            cell_type: "code"
          },
          selected: selected
        }
      ) do
    ~L"""
      <div class="cell">
        <div class="cell-row">
          <span class="gutter">
            In [<%= @cell[:prompt_number] %>]:
          </span>
        <div class="content">
          <form phx-submit="noop" phx-change="update-content">
           <input type="hidden" name="index" value="<%= @idx %>" />
           <input type="hidden" name="cell_type" value="code" />
          <textarea autofocus phx-blur="blur-cell" phx-click="focus-cell" phx-value-ref="<%= @idx %>" phx-hook="NiexCodeEditor" name="text" id="cell-code-<%= @idx %>"><%= Enum.join(@cell[:content], "\n") %></textarea>
         </form>
          <%= if 1 || @selected do %>
          <div class="toolbar">
          <button class="run" phx-click="execute-cell" phx-value-index="<%= @idx %>">
            <i class="fas fa-play"></i>
          </button>
          <button class="remove" phx-click="remove-cell" phx-value-index="<%= @idx %>">
            <i class="fas fa-trash"></i>
          </button>
         </div>
          <% end %>

      </div>
      </div>
      <div class="cell-row">
        <span class="gutter">
            Out [<%= @cell[:prompt_number] %>]:
        </span>
        <span class="content">
          <div class="out">
            <%= raw(Enum.join(Enum.map(@cell[:outputs], & &1[:text]), "\n")) %>
          </div>
        </span>
        </div>
      </div>
    </pre>
    """
  end
end
