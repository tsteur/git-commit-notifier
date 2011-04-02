module GitCommitNotifier::EscapeHelper
  def escape_content(s)
    CGI.escapeHTML(s).gsub(" ", "&nbsp;")
  end
end
