import numpy as np
import cv2

def threshold_image(image, color):
    hsv_image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    hsv_color = cv2.cvtColor(np.uint8([[color]]), cv2.COLOR_BGR2HSV)
    lower = np.array([hsv_color.item(0) - 10, 50, 50])
    upper = np.array([hsv_color.item(0) + 10, 255, 255])
    return cv2.inRange(hsv_image, lower, upper)

def moment(bin_img):
    m = cv2.moments(bin_img, False)
    try:
        cx, cy = m['m10']/m['m00'], m['m01']/m['m00']
    except ZeroDivisionError:
        cx, cy = 240, 320
    return int(cx), int(cy)

def column_found(image, center_x=320, tolerance=50):
    crop = image[:, center_x - tolerance:center_x + tolerance] != 0
    return np.count_nonzero(crop) > 20
