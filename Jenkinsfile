pipeline {
    agent any

    stages {
        stage('checkout') {
            steps {
                // Get some code from a GitHub repository
                sh 'cd /home'
                git branch: 'main', credentialsId:'wordpress', url: 'https://github.com/xyz/AZWordpress.git'
                
            }
        }
        
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        
        stage('Terraform validate') {
            steps {
                sh 'terraform validate'
            }
        }
        
        stage('Terraform plan') {
            steps {
                sh 'terraform plan -out main.plan'
            }
        }
        
        stage('Terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'
                
            }
        }
        
        stage('NAT Rule') {
            steps {
                // Creating NAT Rule required for SSH connectivity
                sh"""
                    az account clear;
                    az login --service-principal -u "XXXXXX" -p "XXXXXX" --tenant "XXXXXX";
                    az account set --subscription "XXXXXXX";
                    az network lb inbound-nat-rule create -g wp3arch-rg --lb-name wp3arch-lb -n SSHNatRule --protocol Tcp --frontend-port-range-start 2221 --frontend-port-range-end 2223 --backend-port 22  --backend-address-pool wp3arch-backend-pool;
                """
                
            }
        }
    }
}
