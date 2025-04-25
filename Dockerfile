FROM continuumio/miniconda3

# 作業ディレクトリ
WORKDIR /root

# 必要パッケージのインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    libgl1 \
    libgl1-mesa-glx \
    libopengl0 \
    libglu1-mesa \
    libx11-6 libxext6 libxi6 libxrandr2 libxinerama1 libxcursor1 \
    libglfw3 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# リポジトリをコピー（またはマウント）
COPY . /root/tbp/tbp.monty/



# 環境作成
WORKDIR /root/tbp/tbp.monty/
# RUN conda env create -f environment.yml

# Conda環境構築（初回のみ）
RUN conda env create -f environment.yml

# zshシェル対応（condaをzsh内で使えるようにする）
RUN conda init zsh

# ↓ ここで以降すべての SHELL を仮想環境付きに変更
SHELL ["conda", "run", "-n", "tbp.monty", "/bin/bash", "-c"]

# データセットと学習済みモデルのダウンロード
RUN python -m habitat_sim.utils.datasets_download --uids ycb --data-path /root/tbp/data/habitat \
 && mkdir -p /root/tbp/results/monty/pretrained_models/ \
 && cd /root/tbp/results/monty/pretrained_models/ \
 && curl -L https://tbp-pretrained-models-public-c9c24aef2e49b897.s3.us-east-2.amazonaws.com/tbp.monty/pretrained_ycb_v10.tgz | tar -xzf -


# Pytest確認（任意）
# CMD ["pytest"]
# CMD ["/bin/bash"]
