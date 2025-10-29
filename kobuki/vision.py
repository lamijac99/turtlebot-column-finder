import cv2
import numpy as np
from utils import ray_distance
from constants import RED, BLUE, GREEN

def threshold_image(robot, COLOR):
    """Segment goal cone by color."""
    image = robot.get_rgb_image()
    hsv_image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    color = np.uint8([[COLOR]])
    hsv_color = cv2.cvtColor(color, cv2.COLOR_BGR2HSV)
    lower_bound = np.array([(hsv_color.item(0)) - 10, 50, 50])
    upper_bound = np.array([(hsv_color.item(0)) + 10, 255, 255])
    mask = cv2.inRange(hsv_image, lower_bound, upper_bound)
    return mask


def mask_cones(robot, color, OBSTACLE1, OBSTACLE2):
    """Segment obstacles by color."""
    if np.array_equal(color, RED):
        color1, color2 = np.uint8([[OBSTACLE1]]), np.uint8([[OBSTACLE2]])
    elif np.array_equal(color, OBSTACLE2):
        color1, color2 = np.uint8([[RED]]), np.uint8([[OBSTACLE1]])
    else:
        color1, color2 = np.uint8([[RED]]), np.uint8([[OBSTACLE2]])

    image = robot.get_rgb_image()
    hsv_image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    hsv_color1 = cv2.cvtColor(color1, cv2.COLOR_BGR2HSV)
    hsv_color2 = cv2.cvtColor(color2, cv2.COLOR_BGR2HSV)

    lower1, upper1 = np.array([(hsv_color1.item(0)) - 10, 50, 50]), np.array([(hsv_color1.item(0)) + 10, 255, 255])
    lower2, upper2 = np.array([(hsv_color2.item(0)) - 10, 50, 50]), np.array([(hsv_color2.item(0)) + 10, 255, 255])

    mask1 = cv2.inRange(hsv_image, lower1, upper1)
    mask2 = cv2.inRange(hsv_image, lower2, upper2)
    return cv2.bitwise_or(mask1, mask2)


def obstacle(image):
    """Detect if any obstacle is close and return direction."""
    out = cv2.connectedComponentsWithStats(image.astype(np.uint8))
    nb_components = out[0] - 1
    direct = 1

    for i in range(nb_components):
        x, y, w, h = out[2][i + 1][:4]
        centroid_x = out[3][i][0]
        if centroid_x < 360:
            direct = -1  # turn away if obstacle is on the left

        dist = ray_distance(x, y, w, h)
        if dist < 0.7:
            return True, direct

    return False, direct
