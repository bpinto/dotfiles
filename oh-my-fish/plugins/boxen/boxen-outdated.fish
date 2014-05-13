function boxen-outdated
  pushd /opt/boxen/repo
  begin; set -x GITHUB_API_TOKEN 6afacc6626025983f3309cf264c8128be48f787f; bundle exec librarian-puppet outdated; end
  popd
end
