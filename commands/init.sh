#!/usr/bin/env bash
# commands/init.sh
# Implements: archforge init <project-name> --arch <architecture>
#
# This command is deliberately generic: it has no knowledge of any
# specific architecture. The flow is always:
#
#   architecture name -> templates/<architecture> -> validate -> copy
#   -> strip ArchForge metadata -> project generated
#
# This file must be sourced by bin/archforge, not executed directly.

cmd_init() {
  local project_name=""
  local arch=""

  # ---------------------------------------------------------------------
  # Argument parsing
  # ---------------------------------------------------------------------
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --arch)
        if [[ $# -lt 2 ]]; then
          error "--arch requires a value."
          return "${EXIT_INVALID_ARGUMENTS}"
        fi
        arch="$2"
        shift 2
        ;;
      --arch=*)
        arch="${1#--arch=}"
        shift
        ;;
      -h|--help)
        cmd_init_usage
        return "${EXIT_SUCCESS}"
        ;;
      --*)
        error "unknown option '$1'."
        cmd_init_usage >&2
        return "${EXIT_INVALID_ARGUMENTS}"
        ;;
      *)
        if [[ -n "${project_name}" ]]; then
          error "unexpected argument '$1'."
          cmd_init_usage >&2
          return "${EXIT_INVALID_ARGUMENTS}"
        fi
        project_name="$1"
        shift
        ;;
    esac
  done

  if [[ -z "${project_name}" ]]; then
    error "missing project name."
    cmd_init_usage >&2
    return "${EXIT_INVALID_ARGUMENTS}"
  fi

  if [[ -z "${arch}" ]]; then
    error "missing --arch <architecture>."
    cmd_init_usage >&2
    return "${EXIT_INVALID_ARGUMENTS}"
  fi

  # ---------------------------------------------------------------------
  # Validation
  # ---------------------------------------------------------------------
  if ! validate_project_name "${project_name}"; then
    return "${EXIT_INVALID_ARGUMENTS}"
  fi

  if ! validate_architecture_exists "${arch}"; then
    error "architecture '${arch}' was not found."
    printf '\nRun:\n\n  archforge list\n' >&2
    return "${EXIT_TEMPLATE_NOT_FOUND}"
  fi

  local target_dir="${PWD}/${project_name}"

  if ! validate_target_directory_available "${target_dir}"; then
    error "directory '${project_name}' already exists."
    return "${EXIT_PROJECT_EXISTS}"
  fi

  # ---------------------------------------------------------------------
  # Generation
  # ---------------------------------------------------------------------
  local template_dir="${ARCHFORGE_TEMPLATES_DIR}/${arch}"

  info "Creating project '${project_name}' with architecture '${arch}'..."

  if ! copy_template_to_project "${template_dir}" "${target_dir}"; then
    error "failed to generate project '${project_name}'."
    return "${EXIT_GENERAL_ERROR}"
  fi

  if ! remove_archforge_metadata "${target_dir}"; then
    warning "failed to remove ArchForge metadata from generated project."
  fi

  success "Project '${project_name}' created successfully."
  return "${EXIT_SUCCESS}"
}

cmd_init_usage() {
  cat <<'EOF'
Usage:

  archforge init <project-name> --arch <architecture>

Options:

  --arch <architecture>   Architecture template to use (see: archforge list)
  --help                  Show this help
EOF
}
