brick.SetColorMode(1, 4)
global key
InitKeyboard();

stopCar = false;
threshold = 85;
while stopCar == false
    %Move forward
    %moveForward();
    brick.MoveMotor('A', -50);
    brick.MoveMotor('D', -50);
    %save distance

    %Fixme: not working right now
    distance = brick.UltrasonicDist(2);
    
    if (distance > threshold)
        brick.MoveMotor('A', 0);
        brick.MoveMotor('D', 0);
        pause(.5)
        brick.MoveMotor('A', -50);
        brick.MoveMotor('D', -50);
        pause(1)
        distance = brick.UltrasonicDist(2);
        if (distance > threshold)
            brick.MoveMotor('A', 50);
            brick.MoveMotor('D', -50);
            pause(.85);
        end
        
        
    elseif distance < 5
        brick.MoveMotor('A', -50);
            brick.MoveMotor('D', -45);
            pause(.5);
    end

    if (brick.TouchPressed(1) == 1);
        brick.MoveMotor('A', 0);
        brick.MoveMotor('D', 0);
        pause(.5)
        brick.MoveMotor('A', 50);
        brick.MoveMotor('D', 50);
        pause(.5)
        brick.MoveMotor('A', -50);
        brick.MoveMotor('D', 50);
        pause(.85)
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
