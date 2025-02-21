FROM jupyter/base-notebook:latest

USER root

# Instala o .NET SDK 8.0 (versão atual em fevereiro de 2025)
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-8.0

# Instala o .NET Interactive como ferramenta global
RUN dotnet tool install -g Microsoft.dotnet-interactive

# Adiciona o .NET Interactive ao PATH
ENV PATH="${PATH}:/root/.dotnet/tools"

# Registra o kernel do .NET Interactive no Jupyter
RUN dotnet interactive jupyter install

# Volta para o usuário padrão do Jupyter
USER $NB_UID

# Define o diretório de trabalho
WORKDIR /home/$NB_USER/work

# Inicia o Jupyter Notebook
CMD ["start-notebook.sh"]
