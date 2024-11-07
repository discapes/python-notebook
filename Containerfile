FROM debian:stable-slim
RUN apt-get update && \
	apt-get install curl ca-certificates unzip doas sqlite3  --no-install-recommends -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* 
RUN useradd user -m
RUN echo "permit nopass user as root" > /etc/doas.conf

USER user
RUN curl -fsSL https://deno.land/install.sh | sh
RUN curl -L micro.mamba.pm/install.sh | SHELL=bash bash
RUN ~/.deno/bin/deno jupyter --install

RUN ~/.local/bin/micromamba install python=3.11 \
	jupyterlab ipywidgets plotly scipy matplotlib numpy \
	pandas dash rpy2 r-irkernel sage xeus-sql soci-sqlite 'notebook>=7.2.2' && \
	~/.local/bin/micromamba clean -afy

RUN ~/.local/bin/micromamba run R -e 'IRkernel::installspec()'
RUN ~/.local/bin/micromamba run bash -c 'ln -s $(sage -sh -c '\''ls -d $SAGE_VENV/share/jupyter/kernels/sagemath'\'') $HOME/.local/share/jupyter/kernels/sagemath-dev'
# We need to set $HOST here or otherwise dash will try to bind to address x86_64-conda-linux-gnu set by micromamba
CMD ~/.local/bin/micromamba run env HOST=127.0.0.1 jupyter lab --ip="0.0.0.0" --IdentityProvider.token=""
