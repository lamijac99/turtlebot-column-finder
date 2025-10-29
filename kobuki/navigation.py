from utils import moment, column_found
from vision import threshold_image, mask_cones, obstacle

def navigate_to_cone(turtle, COLOR, OBSTACLE1, OBSTACLE2):
    """Main navigation loop."""
    ang_vel = 0.2
    lin_vel = 0.3
    full_circle = 0
    obstacle_avoid = False
    goal_x = goal_y = None

    turtle.wait_for_rgb_image()

    while not turtle.is_shutting_down():
        result = threshold_image(turtle, COLOR)
        other_cones = mask_cones(turtle, COLOR, OBSTACLE2, OBSTACLE1)

        cone_ahead, direction = obstacle(other_cones)

        if not obstacle_avoid and not column_found(result):
            print("Searching for the cone...", end="\r")
            turtle.cmd_velocity(linear=0, angular=ang_vel)
            full_circle += ang_vel

            if full_circle > 1620:
                print("Cone not found. Exiting.")
                break
        else:
            full_circle = 0
            goal_x, goal_y = moment(result)
            distance = turtle.get_depth_image()[goal_y, goal_x]

            if cone_ahead:
                print("Obstacle detected!", end="\r")
                obstacle_avoid = True
                turtle.cmd_velocity(linear=0, angular=ang_vel * direction)
                full_circle += ang_vel

                if full_circle > 1620:
                    print("No path found. Stopping.")
                    break
            else:
                full_circle = 0
                if obstacle_avoid:
                    for _ in range(10000):
                        turtle.cmd_velocity(linear=lin_vel, angular=0)
                    obstacle_avoid = False
                else:
                    turtle.cmd_velocity(linear=lin_vel, angular=0)
                    if distance < 0.5:
                        print("---------Reached the goal!---------")
                        break
