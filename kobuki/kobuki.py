#!/usr/bin/env python
from __future__ import print_function
import sys
from robolab_turtlebot import Turtlebot
from constants import RED, BLUE, GREEN
from navigation import navigate_to_cone

if __name__ == '__main__':
    print("Input number of desired cone (1-red, 2-blue, 3-green):")
    x = input().strip()

    COLOR, OBSTACLE1, OBSTACLE2 = RED, BLUE, GREEN
    if x == '1':
        print("You chose red.")
        COLOR, OBSTACLE1, OBSTACLE2 = RED, BLUE, GREEN
    elif x == '2':
        print("You chose blue.")
        COLOR, OBSTACLE1, OBSTACLE2 = BLUE, RED, GREEN
    elif x == '3':
        print("You chose green.")
        COLOR, OBSTACLE1, OBSTACLE2 = GREEN, BLUE, RED
    else:
        print("Wrong input! Defaulting to red goal.")

    turtle = Turtlebot(pc=True, rgb=True, depth=True)
    print("Initializing Turtlebot...")

    navigate_to_cone(turtle, COLOR, OBSTACLE1, OBSTACLE2)
