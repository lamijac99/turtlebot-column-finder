from robolab_turtlebot import Turtlebot

class Robot:
    def __init__(self):
        self.bot = Turtlebot(rgb=True, pc=True, depth=True)

    def get_rgb(self):
        return self.bot.get_rgb_image()

    def get_depth(self, x, y):
        return self.bot.get_depth_image()[y, x]

    def rotate(self, speed=0.2):
        self.bot.cmd_velocity(linear=0, angular=speed)

    def move_forward(self, speed=0.3):
        self.bot.cmd_velocity(linear=speed, angular=0)

    def stop(self):
        self.bot.cmd_velocity(linear=0, angular=0)

    def shutdown(self):
        return self.bot.is_shutting_down()

    def wait_for_image(self):
        self.bot.wait_for_rgb_image()
