from utils import threshold_image, moment
import cv2

def detect_cone(image, color):
    return threshold_image(image, color)

def get_cone_position(bin_img):
    return moment(bin_img)
