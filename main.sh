sudo docker build -f rocm.dockerfile -t rocm-dev .
sudo docker run -it --rm   --device=/dev/kfd   --device=/dev/dri/   -v $(pwd):/workspace   rocm-dev /bin/bash
