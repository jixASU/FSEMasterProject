%brick.SetColorMode(1, 4)
global key
InitKeyboard();

while true
    switch key
        case 'uparrow'
            display('not moving')
            brick.MoveMotor('A', 0);
            brick.MoveMotor('D', 0);
            break;
    end
    while brick.TouchPressed() == 0
        distance = brick.UltrasonicDist(2);
        %color_rgb = brick.ColorRGB(1)
        brick.MoveMotor('A', -50);
        brick.MoveMotor('D', -50);
        if distance > 10
            turnLeft(1)
            stopCar
        end
    end
stopCar
pause(.01)
brick.MoveMotor('A', 50);
brick.MoveMotor('D', 50);
pause(1)
stopCar
end


function turnRight(time)
    brick.MoveMotor('A', 50);
    brick.MoveMotor('D', -50);
    pause(time)
end
function turnLeft(time)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', 50);
    pause(time)
end
function stopCar
    brick.MoveMotor('A', 0);
    brick.MoveMotor('D', 0);
end
%{
check if it can go left
if left open
    turn left and go straight until hit wall
else if right open
    turn right and go straight until hit wall
else if straight open
    go straight until hit wall
else if left, straight, or right not open
    reset (turn back and move forward some)
break
%}
