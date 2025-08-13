#!/bin/bash

# Microservice Factory Setup Script
# This script installs and configures the Microservice Factory CLI tool

set -e

echo "🏭 Microservice Factory Setup"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Python 3.8+ is installed
check_python() {
    echo -e "${BLUE}Checking Python installation...${NC}"
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ Python 3 is required but not installed.${NC}"
        echo "Please install Python 3.8 or higher and try again."
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    echo -e "${GREEN}✅ Python ${PYTHON_VERSION} found${NC}"
    
    # Check if version is 3.8+
    if python3 -c 'import sys; exit(0 if sys.version_info >= (3, 8) else 1)'; then
        echo -e "${GREEN}✅ Python version is compatible${NC}"
    else
        echo -e "${RED}❌ Python 3.8+ is required. Current version: ${PYTHON_VERSION}${NC}"
        exit 1
    fi
}

# Check if pip is installed
check_pip() {
    echo -e "${BLUE}Checking pip installation...${NC}"
    
    if ! command -v pip3 &> /dev/null; then
        echo -e "${RED}❌ pip3 is required but not installed.${NC}"
        echo "Please install pip3 and try again."
        exit 1
    fi
    
    echo -e "${GREEN}✅ pip3 found${NC}"
}

# Check if Docker is installed
check_docker() {
    echo -e "${BLUE}Checking Docker installation...${NC}"
    
    if ! command -v docker &> /dev/null; then
        echo -e "${YELLOW}⚠️  Docker is not installed.${NC}"
        echo "Docker is required to run the generated microservices."
        echo "Please install Docker from https://docs.docker.com/get-docker/"
        echo ""
        read -p "Continue without Docker? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}✅ Docker found${NC}"
        
        # Check Docker Compose
        if docker compose version &> /dev/null; then
            echo -e "${GREEN}✅ Docker Compose found${NC}"
        elif command -v docker-compose &> /dev/null; then
            echo -e "${GREEN}✅ Docker Compose (legacy) found${NC}"
        else
            echo -e "${YELLOW}⚠️  Docker Compose not found${NC}"
            echo "Docker Compose is recommended for development."
        fi
    fi
}

# Install Python dependencies
install_dependencies() {
    echo -e "${BLUE}Installing Python dependencies...${NC}"
    
    # Create requirements.txt
    cat > requirements.txt << EOF
click>=8.0.0
PyYAML>=6.0
Jinja2>=3.1.0
pathlib>=1.0.1
EOF

    pip3 install -r requirements.txt
    echo -e "${GREEN}✅ Dependencies installed${NC}"
}

# Create microfactory command
create_command() {
    echo -e "${BLUE}Creating microfactory command...${NC}"
    
    # Get the current directory
    CURRENT_DIR=$(pwd)
    SCRIPT_PATH="$CURRENT_DIR/microfactory.py"
    
    # Make the script executable
    chmod +x "$SCRIPT_PATH"
    
    # Create a wrapper script in /usr/local/bin (if possible)
    if [ -w "/usr/local/bin" ]; then
        cat > /usr/local/bin/microfactory << EOF
#!/bin/bash
python3 "$SCRIPT_PATH" "\$@"
EOF
        chmod +x /usr/local/bin/microfactory
        echo -e "${GREEN}✅ microfactory command created in /usr/local/bin${NC}"
    else
        # Create in user's local bin
        mkdir -p ~/.local/bin
        cat > ~/.local/bin/microfactory << EOF
#!/bin/bash
python3 "$SCRIPT_PATH" "\$@"
EOF
        chmod +x ~/.local/bin/microfactory
        
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo -e "${YELLOW}⚠️  Added ~/.local/bin to PATH in ~/.bashrc${NC}"
            echo -e "${YELLOW}   Please run: source ~/.bashrc or restart your terminal${NC}"
        fi
        
        echo -e "${GREEN}✅ microfactory command created in ~/.local/bin${NC}"
    fi
}

# Create example project
create_example() {
    echo -e "${BLUE}Creating example project...${NC}"
    
    mkdir -p example-project
    cd example-project
    
    # Copy the architect.yaml example
    cp ../architect.yaml .
    
    echo -e "${GREEN}✅ Example project created in ./example-project${NC}"
    echo -e "${BLUE}To generate services:${NC}"
    echo "  cd example-project"
    echo "  microfactory"
    echo ""
}

# Test installation
test_installation() {
    echo -e "${BLUE}Testing installation...${NC}"
    
    if command -v microfactory &> /dev/null; then
        echo -e "${GREEN}✅ microfactory command is available${NC}"
    else
        echo -e "${YELLOW}⚠️  microfactory command not found in PATH${NC}"
        echo "You may need to restart your terminal or run: source ~/.bashrc"
    fi
}

# Show usage information
show_usage() {
    echo ""
    echo -e "${GREEN}🎉 Installation completed!${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "1. Create a new directory for your project"
    echo "2. Create an architect.yaml file (see example)"
    echo "3. Run: microfactory"
    echo ""
    echo -e "${BLUE}Example:${NC}"
    echo "  mkdir my-microservices"
    echo "  cd my-microservices"
    echo "  cp ../example-project/architect.yaml ."
    echo "  microfactory"
    echo "  docker-compose up -d"
    echo ""
    echo -e "${BLUE}Quick Start with Example:${NC}"
    echo "  cd example-project"
    echo "  microfactory"
    echo "  docker-compose up -d"
    echo ""
    echo -e "${BLUE}Documentation:${NC}"
    echo "  • Check generated README.md for detailed instructions"
    echo "  • API Gateway: http://localhost:8080"
    echo "  • Kafka UI: http://localhost:8081"
    echo ""
}

# Main installation process
main() {
    echo "Starting installation..."
    echo ""
    
    check_python
    check_pip
    check_docker
    install_dependencies
    create_command
    create_example
    test_installation
    show_usage
    
    echo -e "${GREEN}Installation completed successfully! 🚀${NC}"
}

# Check if script is run with sudo (not recommended)
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Please do not run this script with sudo${NC}"
    echo "Run it as a regular user. The script will ask for sudo when needed."
    exit 1
fi

# Run main installation
main