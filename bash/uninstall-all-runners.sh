# Bash script to uninstall all Helm chart runners deployed
for file in ./arc-scalesets/*.yaml; do
  # Extract the base name of the file, removing the path and .yaml extension
  release_name=$(basename "$file" .yaml)
  # Uninstall the Helm release using the modified release name
  helm uninstall "${release_name}-runner" --namespace runners
done