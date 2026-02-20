#!/usr/bin/env bash
set -euo pipefail

#############################################
# 기본 설정 (환경에 맞게 수정)
#############################################

AWS_REGION="ap-northeast-2"
AWS_ACCOUNT_ID="1111111111"        
ECR_REPO_NAME="ecr-repo-name"

#############################################
# 입력값
#############################################

SCOUTER_VERSION="${1:?Usage: ./build_scouter_image.sh <scouter_version>}"

IMAGE_TAG="scouter_server_dev_v${SCOUTER_VERSION}"
LOCAL_IMAGE="${ECR_REPO_NAME}:${IMAGE_TAG}"
ECR_IMAGE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"

#############################################
# 출력 정보
#############################################

echo "=========================================="
echo " Scouter Docker Build & Push"
echo "------------------------------------------"
echo " Scouter Version : ${SCOUTER_VERSION}"
echo " ECR Repo        : ${ECR_REPO_NAME}"
echo " Image Tag       : ${IMAGE_TAG}"
echo " Region          : ${AWS_REGION}"
echo "=========================================="

#############################################
# ECR Login
#############################################

echo "[2/4] Login to ECR..."

aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login \
    --username AWS \
    --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

#############################################
# Docker Build
#############################################

echo "[3/4] Build Docker image..."

docker build \
  --build-arg SCOUTER_VERSION="${SCOUTER_VERSION}" \
  -t "${LOCAL_IMAGE}" \
  .

#############################################
# Tag & Push
#############################################

echo "[4/4] Tag & push image..."

docker tag "${LOCAL_IMAGE}" "${ECR_IMAGE}"
docker push "${ECR_IMAGE}"

#############################################
# 완료 메시지
#############################################

echo "=========================================="
echo " Build & Push Completed"
echo " Image:"
echo "   ${ECR_IMAGE}"
echo "=========================================="

