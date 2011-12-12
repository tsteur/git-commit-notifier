# -*- coding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- vim:fenc=utf-8:filetype=ruby:et:sw=2:ts=2:sts=2

module GitCommitNotifier::EscapeHelper
  def escape_content(s)
    CGI.escapeHTML(s).gsub(" ", "&nbsp;")
  end
end
