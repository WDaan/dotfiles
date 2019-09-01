from pynput.mouse import Listener, Button, Controller
import time
import argparse
import sys
import os
from shutil import get_terminal_size

width = get_terminal_size().columns

if __name__ == '__main__':

    # initlialize the parser
    parser = argparse.ArgumentParser(
        description="Simple script for clicking the mouse!"
    )

    # Add the parameters
    parser.add_argument('-n', '--num', help="Number of times",
                        type=int, required=False, default="25")
    parser.add_argument('-s', '--speed', help="Time between clicks",
                        type=float, required=False, default="0.25")
    
    
    # Parse the arguments
    args = parser.parse_args()

    mouse = Controller()

    print('Clicking {0} times with {1} seconds between clicks'.format(args.num, args.speed).center(width))

    for i in range(args.num):
        mouse.click(Button.left, 1)
        time.sleep(args.speed)
