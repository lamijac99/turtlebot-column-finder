import numpy as np

# Color definitions
BLUE = [102, 0, 0]
RED = [0, 0, 102]
GREEN = [0, 102, 0]

# Camera intrinsic matrix (RGB camera)
Krgb = np.array([
    [554.25469119, 0, 320.5],
    [0, 554.25469119, 240.5],
    [0, 0, 1]
])
