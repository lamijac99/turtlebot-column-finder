from robot_interface import Robot
from cone_detector import detect_cone, get_cone_position
from obstacle_detector import detect_obstacle, create_mask
from utils import column_found
from constants import RED, BLUE, GREEN, Krgb

import sys

color_map = {'1': RED, '2': BLUE, '3': GREEN}

def choose_color():
    print("Choose cone color (1-Red, 2-Blue, 3-Green):")
    key = input()
    return color_map.get(key, RED)

def main():
    COLOR = choose_color()
    OBSTACLES = [c for c in [RED, BLUE, GREEN] if not (c == COLOR)]

    robot = Robot()
    robot.wait_for_image()

    full_circle = 0
    obstacle_avoid = False

    while not robot.shutdown():
        rgb = robot.get_rgb()
        cone_mask = detect_cone(rgb, COLOR)
        obstacle_mask = create_mask(rgb, OBSTACLES)

        cone_found = column_found(cone_mask)
        obs_detected, direction = detect_obstacle(obstacle_mask, Krgb)

        if not cone_found and not obstacle_avoid:
            print("Searching for cone...", end="\r")
            robot.rotate()
            full_circle += 1
            if full_circle > 200:  # arbitrary loop count for full spin
                print("Cone not found. Stopping.")
                break
        else:
            full_circle = 0
            cx, cy = get_cone_position(cone_mask)
            distance = robot.get_depth(cx, cy)

            if obs_detected:
                print("Obstacle ahead! Avoiding...", end="\r")
                robot.rotate(0.2 * direction)
                obstacle_avoid = True
            elif distance > 0.5:
                print("Moving towards cone...", end="\r")
                robot.move_forward()
            else:
                print("Goal reached!")
                robot.stop()
                break

if __name__ == "__main__":
    main()
