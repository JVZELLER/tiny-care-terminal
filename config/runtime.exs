import Config

config :tiny_care_terminal, TinyCareTerminal.Commands.ListCommitHistory,
  path: System.get_env("GIT_REPO_PATH", "")
