FROM jupyter/base-notebook:latest

USER root

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y dotnet-sdk-8.0

RUN dotnet tool install -g Microsoft.dotnet-interactive
ENV PATH="${PATH}:/root/.dotnet/tools"
RUN dotnet interactive jupyter install

USER $NB_UID
WORKDIR /home/$NB_USER/work
CMD ["start-notebook.sh"]
