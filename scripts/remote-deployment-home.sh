# Exit immediately if a command exits with a non-zero status.
set -e

# --- Color Variables ---
COLOR='\e[94m'
NC='\e[0m' # No Color (to reset)

# --- Configuration ---
# Prioritize command-line args, but fall back to env vars.
flakedir="${1:-$DEPLOY_FLAKE}"
configname="${2:-$DEPLOY_USER_CONFIG_NAME}"
user="${3:-$DEPLOY_USER}"
hostname="${4:-$DEPLOY_HOST}"

# After attempting to set them, check if they are still empty.
if [ -z "$flakedir" ] || [ -z "$configname" ] || [ -z "$user" ] || [ -z "$hostname" ]; then
  echo "❌ Error: flakedir/configname/user/hostname not specified."
  echo "Provide them as arguments or set env variables."
  echo ""
  echo "Usage (Args): $0 <flakedir> <configname> <user> <hostname>"
  echo "Usage (Envs): DEPLOY_FLAKE=~/dots DEPLOY_CONFIG_NAME=leon-pi ..."
  exit 1
fi

remote_host="${user}@${hostname}"
flake_target="${flakedir}/#homeConfigurations.${configname}"

# --- Script Logic ---

echo -e "${COLOR}Building home configuration '${configname}'${NC}"

out_path=$(nix build "${flake_target}.activationPackage" --print-out-paths --no-link)
echo -e "${COLOR}Build complete. Store path: ${out_path}${NC}"

echo -e "${COLOR}Copying derivation to ${remote_host}...${NC}"
nix copy "${out_path}" --to "ssh://${remote_host}"

echo -e "${COLOR}Activating configuration on ${remote_host}...${NC}"
# Use `ssh -t` to force TTY allocation and get color output.
ssh -t "${remote_host}" "${out_path}/activate"

echo -e "${COLOR}✅ Deployment to ${remote_host} successful!${NC}"