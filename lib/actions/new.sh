#!/usr/bin/env bash
action_new() {
  local branch='' official_spin_template='' template_repository=''

  if [ $# -lt 1 ]; then
    printf "${BOLD}${YELLOW}🤔 You didn't pass \"spin new\" any arguments. Run \"spin help\" if you want to see the documentation.${RESET}\n"
    exit 1
  fi

  # Argument parsing
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -b|--branch)
        branch="$2"
        shift 2  # Shift both the flag and its value
        ;;
      *)
        if [[ -z "$template_repository" ]]; then
          template="$1"  # Capture the first non-flag argument as template
        fi
        shift  # Shift past the processed argument
        ;;
    esac
  done

  # Determine the type of template
  case "$template" in
    laravel)
      official_spin_template=true
      template_repository="serversideup/spin-laravel-template"
      ;;
    nuxt)
      official_spin_template=true
      template_repository="serversideup/spin-nuxt-template"
      ;;
    *)
      official_spin_template=false
      template_repository="$template"
      ;;
  esac

  # Third-party repository warning and confirmation
  if [[ "$official_spin_template" != true ]]; then
    if [ -z "$branch" ]; then
      branch=$(github_default_branch "$repo")
    fi
    check_if_template_exists_and_has_access "$template_repository" "$branch"

    echo "${BOLD}${YELLOW}⚠️ You're downloading content from a third party repository.${RESET}"

    display_repository_metadata "$template_repository" "$branch"
    echo "${BOLD}${BLUE}Make sure you trust the source of the repository before continuing.${RESET}"
    echo "Do you wish to continue? (y/n)"
    read -r -n 1 -p ""
    echo  # Move to a new line

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${BOLD}${RED}❌ Operation cancelled.${RESET}"
      exit 1
    fi
  fi

  

}