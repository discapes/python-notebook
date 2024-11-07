FROM debian:stable-slim
RUN apt-get update
RUN apt-get install curl unzip -y
RUN useradd user -m

RUN apt-get install doas --no-install-recommends -y
RUN echo "permit nopass user as root" > /etc/doas.conf

USER user
RUN curl -fsSL https://deno.land/install.sh | sh
RUN curl -L micro.mamba.pm/install.sh | SHELL=bash bash
RUN ~/.deno/bin/deno upgrade rc
RUN ~/.deno/bin/deno jupyter --install
RUN ~/.local/bin/micromamba install python=3.11 jupyterlab ipywidgets plotly scipy matplotlib numpy pandas dash rpy2
RUN ~/.local/bin/micromamba install r-irkernel
RUN ~/.local/bin/micromamba run R -e 'IRkernel::installspec()'
CMD ~/.local/bin/micromamba run jupyter lab --ip=0.0.0.0 --ServerApp.token=""
