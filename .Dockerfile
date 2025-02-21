FROM mcr.microsoft.com/dotnet/core/sdk:3.1-focal

USER root
RUN cd /tmp
# now get the key:
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
# now install that key
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
# now remove the public key file exit the root shell
RUN rm GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

# we have to get this because the linux mlnet nuget expects a dependency that only ships with windows.
# so we add the public key as shown above and apt-get install intel-mkl-64bit-2020.0.088 
RUN sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install python3 python3-pip python3-dev ipython3 intel-mkl-64bit-2020.0-088

RUN find /opt -name "libiomp5.so"
RUN ldconfig /opt/intel/compilers_and_libraries_2020.0.166/linux/compiler/lib/intel64_lin/

RUN pip3 install --no-cache notebook

ARG NB_USER=jovyan
ARG NB_UID=1000
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

USER $NB_USER

ENV HOME=/home/$NB_USER

WORKDIR $HOME

ENV PATH="${PATH}:$HOME/.dotnet/tools/"

RUN dotnet tool install -g --add-source "https://dotnet.myget.org/F/dotnet-try/api/v3/index.json" dotnet-interactive

RUN dotnet-interactive jupyter install
