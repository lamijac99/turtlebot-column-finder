import cv2
import numpy as np
from constants import Krgb

def ray_distance(x, y, w, h):
    """Estimate distance using cone width in image."""
    r = 0.025  # physical radius of the cone (approx.)
    u1_hom = np.array([x, (y + h) / 2, 1])
    u2_hom = np.array([x + w, (y + h) / 2, 1])

    x1 = np.matmul(np.linalg.inv(Krgb), u1_hom)
    x2 = np.matmul(np.linalg.inv(Krgb), u2_hom)

    cos_angle = np.dot(x1, x2) / (np.linalg.norm(x1) * np.linalg.norm(x2))
    alpha = np.arccos(cos_angle)
    z = r / np.sin(alpha / 2)
    return z


def moment(bin_img):
    """Return centroid (cx, cy) of a binary image."""
    m = cv2.moments(bin_img, False)
    try:
        cx, cy = m['m10'] / m['m00'], m['m01'] / m['m00']
    except ZeroDivisionError:
        cx, cy = 240, 320
    return int(cx), int(cy)


def column_found(image):
    """Check if goal cone is centered in image."""
    middle = 320
    crop = image[:, middle - 50:middle + 50] != 0
    white_pixels = np.count_nonzero(crop)
    return white_pixels > 20
