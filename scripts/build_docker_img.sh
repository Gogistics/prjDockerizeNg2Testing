IMAGE_NAME="ng2-app"
IMAGE_VERSION="v1"

# Check if the docker image exists
app_image="$IMAGE_NAME:$IMAGE_VERSION"
inspect_result=$(docker inspect $app_image)

if [[ "[]" == "$inspect_result" ]]; then
  echo "Docker image, $app_image, does not exist and a new one will be created"
  docker build -t ${app_image} .
  echo "↪"
  echo "Image is created and go to next step"
else
  echo "Docker image, $app_image, already exists"
  echo "go to next step"
fi