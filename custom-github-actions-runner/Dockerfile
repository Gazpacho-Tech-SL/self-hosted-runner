# Use a custom GitHub Actions Runner image as the base
# This image provides a pre-configured environment that includes necessary tools and dependencies
# for running GitHub Actions workflows efficiently. Custom runner images allow for:
# 
# 1. **Consistency:** Ensures that the build environment is consistent across different workflows and jobs.
# 2. **Pre-installed Tools:** Includes tools and utilities that are required for the build and deployment process,
#    such as curl, wget, Java, AWS CLI, Helm, and Terraform, which reduces setup time and complexity.
# 3. **Customization:** Allows for custom configurations and software installations tailored to the specific needs of
#    the project or organization, improving build reliability and efficiency.
# 4. **Isolation:** Provides an isolated environment for each build, preventing conflicts and ensuring that builds are
#    repeatable and reliable.
# 
# By using this custom image, we streamline the workflow setup process and ensure that all required tools are readily available.

# Use a specific GitHub Actions Runner image as the base
FROM ghcr.io/actions/actions-runner:2.319.1

# Install necessary utilities and packages
# This includes curl, wget, java-common, and apt-transport-https for managing packages and fetching external files
RUN sudo apt-get update && \
    sudo apt-get install -y curl wget java-common apt-transport-https unzip gettext

# Install Amazon Corretto 17 JDK
# Add Corretto's GPG key, configure the repository, and install the JDK
RUN wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list && \
    sudo apt-get update && sudo apt-get install -y java-17-amazon-corretto-jdk    

# Install AWS CLI
# Download and unzip the AWS CLI installation package, then run the installer
RUN curl -O https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip awscli-exe-linux-x86_64.zip && \
    sudo ./aws/install    

# Install Helm
# Add Helm's GPG key, configure the repository, and install Helm version 3.15.1
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    sudo apt-get update && sudo apt-get install helm=3.15.1-*

# Install Terraform
# Add HashiCorp's GPG key, configure the repository, and install Terraform version 1.9.1
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list && \
    sudo apt-get update && sudo apt-get install -y terraform=1.9.1-*
