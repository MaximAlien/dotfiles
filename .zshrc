source .common
source .aliases

shell_startup

# Show current time on prompt located on the right
# RPROMPT="%*"

# Adding functions to `precmd_functions` allows to run it before each prompt.
# precmd_functions+=(git_branch_info)
setopt PROMPT_SUBST

# %F - foreground color
# %f - reset to default color
# %B - bold
# %b - reset bold
PROMPT='%~$(git_branch_info) $ '