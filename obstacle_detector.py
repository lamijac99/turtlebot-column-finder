import numpy as np
import cv2
from constants import Krgb

def ray_distance(x, y, w, h, K_rgb):
    r = 0.025
    u1 = np.array([x, (y + h) / 2, 1])
    u2 = np.array([x + w, (y + h) / 2, 1])
    x1 = np.linalg.inv(K_rgb) @ u1
    x2 = np.linalg.inv(K_rgb) @ u2
    alpha = np.arccos(np.dot(x1, x2) / (np.linalg.norm(x1) * np.linalg.norm(x2)))
    return r / np.sin(alpha / 2)

def detect_obstacle(image, K_rgb):
    out = cv2.connectedComponentsWithStats(image.astype(np.uint8))
    direct = 1
    for i in range(1, out[0]):
        x, y, w, h = out[2][i][:4]
        if out[3][i][0] < 360:
            direct = -1
        if ray_distance(x, y, w, h, K_rgb) < 0.7:
            return True, direct
    return False, direct

def create_mask(image, colors):
    hsv_image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    mask = None
    for color in colors:
        hsv = cv2.cvtColor(np.uint8([[color]]), cv2.COLOR_BGR2HSV)
        lower = np.array([hsv.item(0) - 10, 50, 50])
        upper = np.array([hsv.item(0) + 10, 255, 255])
        current = cv2.inRange(hsv_image, lower, upper)
        mask = current if mask is None else cv2.bitwise_or(mask, current)
    return mask
