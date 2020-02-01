module AshTest where

import RobotPath
import Inf2d1


main_test =
    do  findPath (1,1) (6,6) (5,0)
        findPath (1,1) (5,5) (4,0)
        findPath (1,1) (6,2) (4,0)
