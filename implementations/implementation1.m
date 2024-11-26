brick.SetColorMode(1, 4)
global key
InitKeyboard();

stopCar = false;
threshold = 200;
while stopCar == false
    %Move forward
    %moveForward();
    %brick.MoveMotor('A', -50);
    %brick.MoveMotor('D', -50);
    %save distance

    %Fixme: not working right now
    distance = brick.UltrasonicDist('1');
    
    if (distance > threshold)
        brick.MoveMotor('A', 0);
        brick.MoveMotor('D', 0);
        pause(.5)
        brick.MoveMotor('A', 50);
        brick.MoveMotor('D', 50);
        pause(.5)
        brick.MoveMotor('A', 50);
        brick.MoveMotor('D', -50);
        pause(.5);
    end

    if (brick.TouchPressed(3) == 1);
        brick.MoveMotor('A', 0);
        brick.MoveMotor('D', 0);
        pause(.5)
        brick.MoveMotor('A', 50);
        brick.MoveMotor('D', 50);
        pause(.5)
        brick.MoveMotor('A', -50);
        brick.MoveMotor('D', 50);
        pause(.5)
    end
    
end
%{
brick.MoveMotor('A', 0);
brick.MoveMotor('D', 0);
pause(.01)
brick.MoveMotor('A', 50);
brick.MoveMotor('D', 50);
pause(.5)
brick.MoveMotor('A', -50);
brick.MoveMotor('D', 50);
pause(.5)
brick.MoveMotor('A', 0);
brick.MoveMotor('D', 0);
break;
%}





function turnLeft(time)
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', 50);
    pause(time)
end
function moveForward()
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', -50);
end
function stopCarFunc(time)
    brick.MoveMotor('AD', 0);
    pause(time)
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
