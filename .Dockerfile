# Usa a imagem base oficial do Jupyter Notebook
FROM jupyter/base-notebook:latest

# Define o usuário como root para instalar pacotes
USER root

# Instala o .NET SDK (necessário para o .NET Interactive)
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-8.0

# Instala o .NET Interactive como uma ferramenta global
RUN dotnet tool install -g Microsoft.dotnet-interactive

# Adiciona o .NET Interactive ao PATH
ENV PATH="${PATH}:/root/.dotnet/tools"

# Registra o kernel do .NET Interactive no Jupyter
RUN dotnet interactive jupyter install

# Volta para o usuário padrão do Jupyter (jovyan) por segurança
USER $NB_UID

# Define o diretório de trabalho
WORKDIR /home/$NB_USER/work

# Inicia o Jupyter Notebook
CMD ["start-notebook.sh"]
