# OpenCourant solver runtime image.
#
# Built by the Delivery stable CI pipeline from the release package of the
# matching architecture (OpenCourant_linux64.zip on amd64,
# OpenCourant_linuxa64.zip on arm64) and published as a multi-arch image:
#
#   ghcr.io/opencourant/opencourant:latest-YYYYMMDD
#   ghcr.io/opencourant/opencourant:latest
#
# The OpenMPI 4.1.2 runtime is copied from the OpenCourant build image
# (same toolchain that built the solver), so the *_ompi engines work out
# of the box:
#
#   docker run -v $PWD:/work ghcr.io/opencourant/opencourant \
#       starter -i MODEL_0000.rad -np 4
#   docker run -v $PWD:/work ghcr.io/opencourant/opencourant \
#       mpiexec -np 4 engine_ompi -i MODEL_0001.rad

ARG BLD_IMAGE=ghcr.io/opencourant/linux64-bld-qa:ompi4.1.2
FROM ${BLD_IMAGE} AS ompi

FROM docker.io/rockylinux/rockylinux:9

# linux64 on amd64, linuxa64 on arm64
ARG ARCH_DIR=linux64
ARG PKG_ZIP=OpenCourant_linux64.zip

# libxcrypt-compat: the solver binaries are built on EL8 and link
# libcrypt.so.1, which EL9 only provides through this package
RUN dnf -y install unzip hostname which libxcrypt-compat openssh-clients && dnf clean all && rm -rf /var/cache/dnf

COPY ${PKG_ZIP} /tmp/opencourant.zip
RUN unzip -q /tmp/opencourant.zip -d /opt && \
    rm /tmp/opencourant.zip && \
    chmod 755 /opt/OpenCourant/exec/*

# OpenMPI 4.1.2 runtime, built with the same toolchain as the solver
COPY --from=ompi /opt/openmpi /opt/openmpi

# Convenience names next to the arch-suffixed executables
RUN cd /opt/OpenCourant/exec && \
    ln -s starter_${ARCH_DIR}_gf       starter && \
    ln -s starter_${ARCH_DIR}_gf_sp    starter_sp && \
    ln -s engine_${ARCH_DIR}_gf        engine && \
    ln -s engine_${ARCH_DIR}_gf_sp     engine_sp && \
    ln -s engine_${ARCH_DIR}_gf_ompi    engine_ompi && \
    ln -s engine_${ARCH_DIR}_gf_ompi_sp engine_ompi_sp

ENV OPENCOURANT_PATH=/opt/OpenCourant \
    RAD_CFG_PATH=/opt/OpenCourant/hm_cfg_files \
    OMP_STACKSIZE=400m \
    OMPI_ALLOW_RUN_AS_ROOT=1 \
    OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
    PATH=/opt/OpenCourant/exec:/opt/openmpi/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

ENV LD_LIBRARY_PATH=/opt/OpenCourant/extlib/hm_reader/${ARCH_DIR}:/opt/OpenCourant/extlib/h3d/lib/${ARCH_DIR}:/opt/openmpi/lib

LABEL org.opencontainers.image.source="https://github.com/OpenCourant/OpenCourant" \
      org.opencontainers.image.description="OpenCourant explicit finite element solver (Starter + Engine, SMP and OpenMPI)" \
      org.opencontainers.image.licenses="AGPL-3.0-or-later"

WORKDIR /work
CMD ["/bin/bash"]
